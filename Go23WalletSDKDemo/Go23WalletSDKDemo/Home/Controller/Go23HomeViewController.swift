//
//  Go23HomeViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import UIKit
import SnapKit
import MBProgressHUD
import BigInt
import Alamofire
import Go23SDK

class Go23WalletMangager {
    static let shared = Go23WalletMangager()
    var walletModel: Go23WalletChainModel?
    var address = ""
    var email = ""
    var balance = ""
    var balanceU = ""
    var scope = ""
    var clientId = ""
    
}

class Go23HomeViewController: UIViewController, Go23NetStatusProtocol {
    
    private var authScope: String?
    private var authClientId: String?
    private var isShowAuthed: Bool = false
    private var hasOauth: Bool = false

    private var tokenListTimer: Timer?
    private var timeInterval: Int = 15
    private var email = ""
    
    var userinfo: UserInfoModel?
    var walletList: [Go23WalletInfoModel]?
    var chainList: [Go23WalletChainModel]?
    
    
    var tokenList: [Go23WalletTokenModel]?
    
    var hud: MBProgressHUD?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
                
        NotificationCenter.default.addObserver(self, selector: #selector(registerUser), name: NSNotification.Name(rawValue: kRegisterUser), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerUser), name: NSNotification.Name(rawValue: kRefreshWalletData), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getChainBalance), name: Notification.Name(rawValue: kRefreshWalletBalance), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(authMethod), name: NSNotification.Name(rawValue: "oauthPost"), object: nil)

//        creatTimer()
        
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
//        removeTimer()
    }
    
    private func initSubViews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
                
        headerView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(HomeHeaderView.cellHight)
        }
        
        view.addSubview(segmentedView)
        view.addSubview(listContainerView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        
        
        dataSource.titles = ["Tokens", "NFTs"]
        dataSource.widthForTitleClosure = { name in
            return String.getStringWidth(name,font: UIFont(name: BarlowCondensed, size: 16)!)+24
        }
        dataSource.titleNormalFont = UIFont(name: BarlowCondensed, size: 16)!
        dataSource.titleSelectedFont = UIFont(name: BarlowCondensed, size: 16)!
        dataSource.titleSelectedColor = UIColor.white
        dataSource.titleNormalColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        dataSource.kern = 1
        segmentedView.dataSource = dataSource
        segmentedView.reloadData()
        
        segmentedView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }

    }
    
        
    
    // MARK: - Action
    private func creatTimer() {
        tokenListTimer = Timer(timeInterval: 20.0, repeats: true) { [weak self] timer in
            self?.registerUser()
        }
        guard let timer = tokenListTimer else {
            return
        }
        RunLoop.current.add(timer, forMode: .common)
        
    }
    
    private func removeTimer() {
        self.tokenListTimer?.invalidate()
        self.tokenListTimer = nil
    }
    
    private func popSettingEmail() {
        if let kEmail = UserDefaults.standard.string(forKey: kEmailPrivateKey), kEmail.count > 0 {
            return
        }
        let alert = Go23SettingEmailView(frame: CGRectMake(0, 0, ScreenWidth, 720))
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true
        alert.confirmBlock = {[weak self] in
            self?.registerUser()
            if let view = self?.view {
                Go23Loading.loading()
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    view.dissmiss(overlay: .last)
                }
            }
        }
        alert.closeBlock = { [weak self] in
            if let view = self?.view {
                view.dissmiss(overlay: .last)
            }
        }
        self.view.present(overlay: ovc)
    }
    
    @objc private func settingBtnDidClick() {
        
        let alert = Go23SettingView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-120))
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true
        
        alert.reshardingBlock = {[weak self] pk in
            self?.reshardWallet(pk: pk)
        }
        
        alert.cancelBlock = { [weak self] in
            self?.view.dissmiss(overlay: .last)
        }

        self.view.present(overlay: ovc)
    }
    
    private func reshardWallet(pk: String) {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        shared.reshardWallet(with: Go23WalletMangager.shared.address, shard: pk, delegate: self) {[weak self] result in
                switch result {
                case .success(let str):
                    self?.view.dissmiss(overlay: .last)
                    UserDefaults.standard.set(str, forKey: kPrivateKeygenKey)
                    if  let keygen = UserDefaults.standard.value(forKey: kPrivateKeygenKey) as? String, keygen.count > 0 {
                        Go23Net.updateServerShard(with: keygen, address: Go23WalletMangager.shared.address) { status in
                            if status {
                                UserDefaults.standard.set("", forKey: kPrivateKeygenKey)
                            }
                        }
                    }
                    let alert = Go23PwdSuccessView(frame: CGRectMake(0, 0, ScreenWidth, 720))
                    let ovc = OverlayController(view: alert)
                    ovc.maskStyle = .black(opacity: 0.4)
                    ovc.layoutPosition = .bottom
                    ovc.presentationStyle = .fromToBottom
                    ovc.isDismissOnMaskTouched = false
                    ovc.isPanGestureEnabled = true
                    UIApplication.shared.keyWindow?.present(overlay: ovc)
                case .failure(let status):
                    switch status {
                    case .forgetPincode:
                        self?.view.dissmiss(overlay: .last)
                        let alert = Go23ReshardingView(frame: CGRectMake(0, 0, ScreenWidth, 720),type: .resharding)
                        let ovc = OverlayController(view: alert)
                        ovc.maskStyle = .black(opacity: 0.4)
                        ovc.layoutPosition = .bottom
                        ovc.presentationStyle = .fromToBottom
                        ovc.isDismissOnMaskTouched = false
                        ovc.isPanGestureEnabled = true
                        
                        UIApplication.shared.keyWindow?.present(overlay: ovc)
                    case .errorPincode:
                        let totast = Go23Toast.init(frame: .zero)
                        totast.show("Pincode error, please try again!", after: 1)
                    case .cancelReshard:
                        self?.view.dissmiss(overlay: .last)
                        let totast = Go23Toast.init(frame: .zero)
                        totast.show("Pincode cancel, please try again!", after: 1)
                    default:
                        break
                    }
                    break
                }
        }
    }
    
    
     @objc private func addBtnClick() {
        let alert = Go23AddView(frame: CGRectMake(0, 0, ScreenWidth, 300))
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true
         
        UIApplication.shared.keyWindow?.present(overlay: ovc)
    }
    
    private lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView()
        view.delegate = self
        return view
    }()
    
    let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    private lazy var segmentedView: JXSegmentedView = {
        
        let segmentedView = JXSegmentedView()
        segmentedView.contentEdgeInsetLeft = 30
        segmentedView.contentEdgeInsetRight = ScreenWidth - 120
        segmentedView.delegate = self
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorCornerRadius = 6.0
        indicator.verticalOffset = 1
        indicator.indicatorColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        indicator.layer.shadowColor = UIColor.black.cgColor
        indicator.layer.shadowOffset = CGSize(width:1, height:1)
        indicator.layer.shadowRadius = 6
        indicator.layer.shadowOpacity = 0.08
        segmentedView.indicators = [indicator]
        return segmentedView
    }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "add")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(16)
        }
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
    }()
    

}

extension Go23HomeViewController: HomeHeaderViewDelegate {
    func chooseClick() {
        
        let alert = Go23ChooseAlertView(frame: CGRectMake(0, 0, ScreenWidth, 700))
        
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true
        
        alert.chainList = self.chainList
        alert.chooseBlock = {[weak self]model in
            Go23WalletMangager.shared.walletModel = model
            self?.headerView.filled(money: Go23WalletMangager.shared.balance, symbol: model.symbol, chainName: model.name,balanceU: Go23WalletMangager.shared.balanceU)
            self?.headerView.chooseV.filled(title: model.name, img: model.imageUrl)
            self?.registerUser()
            self?.setDefaultChain(with: model.walletAddress, and: model.chainId)
            
        }
        UIApplication.shared.keyWindow?.present(overlay: ovc)
    }
    
    func receiveBtnClick() {
        let alert = Go23ReceiveView(frame: CGRectMake(0, 0, 332, Go23ReceiveView.cellHeight))
        alert.filled(title: Go23WalletMangager.shared.walletModel?.name ?? ""    , qrcode: Go23WalletMangager.shared.address)
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .center
        ovc.presentationStyle = .fade
        ovc.isDismissOnMaskTouched = true
        ovc.isPanGestureEnabled = true

        UIApplication.shared.keyWindow?.present(overlay: ovc)
        
    }
    func sendBtnClick() {
        let vc = Go23SendViewController()
        vc.filled(cover: Go23WalletMangager.shared.walletModel?.imageUrl ?? "", name: Go23WalletMangager.shared.walletModel?.name ?? "", chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, symbol: Go23WalletMangager.shared.walletModel?.symbol ?? "", contract: "")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func settingBtnClick() {
        self.settingBtnDidClick()
    }

}

// MARK: - pragma mark =========== JXSegmentedViewDelegate ===========

extension Go23HomeViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
            segmentedView.dataSource = dataSource
            segmentedView.reloadItem(at: index)
    }
}

// MARK: - pragma mark =========== JXSegmentedListContainerViewDataSource ===========
extension Go23HomeViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = Go23TokenListViewController()
            return vc
        } else {
            let vc = Go23NFTListViewController()
            return vc
        }

    }
    
}


//SDK
extension Go23HomeViewController {
       
    private func recover(walletlist: [Go23WalletInfoModel]) {
        self.hud?.hide(animated: true)
        self.walletList = walletlist
        guard walletlist.count > 0 else {return}
        let wallet = walletlist[0]
        Go23WalletMangager.shared.address = wallet.address
        let alert = Go23ReshardingView(frame: CGRectMake(0, 0, ScreenWidth, 720),type: .recover, isShow: false)
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true

        UIApplication.shared.keyWindow?.present(overlay: ovc)
    }
    
    @objc private func registerUser() {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        print("registerUser")
        
        popSettingEmail()

        guard let kEmail = UserDefaults.standard.string(forKey: kEmailPrivateKey), kEmail.count > 0 else  {
            return
        }
        
        Go23WalletMangager.shared.email = kEmail

        Go23Loading.loading()
        shared.connect(with: Go23WalletMangager.shared.email, email: Go23WalletMangager.shared.email, delegate: self) { [weak self] result in
            switch result {
            case .success(let successResult):
                switch successResult {
                case .walletCreated(let address, let shard):
                    self?.createWallet(address: address, shard: shard)
                    print("user address = \(address), user shard = \(shard)")
                case .recover(let walletlist):
                    self?.recover(walletlist: walletlist)
                case .wallets(let walletlist):
                    self?.getWalletList(walletlist: walletlist)
                @unknown default:
                    fatalError()
                }
            case .failure(let faildResult):
                Go23Loading.clear()
                switch faildResult {
                case .walletError(let code, let message):
                    print("walletError code = \(code), message = \(message)")
                case .networkError(let code, let message):
                    print("networkError code = \(code), message = \(message)")
                case .walletCreateFailed(let message):
                    print("walletCreateFailed message = \(message)")
                case .accountError(let code, let message):
                    print("accountError code = \(code), message = \(message)")
                @unknown default:
                    fatalError()
                }
            }
        }
        
        headerView.filled(cover: "go23", email: Go23WalletMangager.shared.email)
        
    }
    
    private func createWallet(address: String, shard: String) {
        Go23WalletMangager.shared.address = address
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        Go23Loading.loading()
        if shard.count > 0 {
                UserDefaults.standard.set(shard, forKey: kPrivateKeygenKey)
                self.uploadKeygen()
                shared.fetchUserWallets {[weak self] status in
                    Go23Loading.clear()
                    switch status {
                    case .success(let succStatus):
                        switch succStatus {
                        case .wallets(let walletlist):
                            //After the first successful creation, the access party needs to manually adjust the interface
                            self?.getWalletList(walletlist: walletlist)
                        default:
                            break
                        }
                    default:
                        break
                    }
                }
        }
    }
    
    private func getWalletList(walletlist: [Go23WalletInfoModel]) {
        self.walletList = walletlist
        guard walletlist.count > 0 else {return}
        let wallet = walletlist[0]
        Go23WalletMangager.shared.address = wallet.address
        self.uploadKeygen()
        print("Address ========   \(wallet.address)")
        self.headerView.filled(address: wallet.address)
        self.getUserChains(with: wallet.address)
        
        authMethod()
    }
    
    private func isHasWallet() -> Bool {
        if self.walletList == nil {
            return false
        } else {
            return true
        }
    }
    
    @objc private func authMethod() {
        self.authScope = Go23WalletMangager.shared.scope
        self.authClientId = Go23WalletMangager.shared.clientId
        
        guard let scope = self.authScope,
              let clientId = self.authClientId,isShowAuthed == false else {
            // make sure auth info is correct
            return
        }
        hasOauth = true
        if isHasWallet() {
            ArcadeOAuthManager.default.scope = scope
            ArcadeOAuthManager.default.clientId = clientId
            self.getOAuthClientInfo(with: clientId)
        }
        
    }
    
    private func getUserChains(with walletAddress: String) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        shared.fetchWalletChainlist(with: walletAddress, pageSize: 10, pageNumber: 1) { [weak self] chainModel in
            guard let list = chainModel?.listModel else {
                return
            }
            self?.chooseDefaultWallet(list: list)
        }

    }
    
    private func chooseDefaultWallet(list: [Go23WalletChainModel]) {
        self.chainList = list
        for obj in list{
            if obj.hasDefault {
                Go23WalletMangager.shared.walletModel = obj
                self.getUserTokens(with: obj.chainId)
                self.getChainBalance()
                self.headerView.chooseV.filled(title: obj.name, img: obj.imageUrl)
            }
        }

    }
    private func getUserTokens(with chainId: Int) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        shared.getWalletTokenList(with: Go23WalletMangager.shared.address, chainId: chainId, pageSize: 10, pageNumber: 1) { [weak self]model in
            
            Go23Loading.clear()
            guard let list = model?.listModel else {
                return
            }
            self?.tokenList = list
            self?.segmentedView.reloadData()
            
        }
    }
    
    @objc private func getChainBalance() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        shared.getChainTokenBalance(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0) { [weak self](balanceModel) in
            guard let bal = balanceModel?.balance, let balU = balanceModel?.balanceU else {
                return
            }
            
            self?.headerView.filled(money: bal,symbol:  Go23WalletMangager.shared.walletModel?.symbol ?? "", chainName: Go23WalletMangager.shared.walletModel?.name ?? "",balanceU: balU)
            Go23WalletMangager.shared.balance = bal
            Go23WalletMangager.shared.balanceU = balU
            print(balanceModel)
        }
        
    }
    
    private func setDefaultChain(with address: String, and chainId: Int) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        shared.setCurrentChain(with: address, chainId: chainId) { obj in
            
        }
    }
     
    //This piece of private key is uploaded to the access party's own server, it is best to do encryption processing, here is the demo directly in plain text
    private func uploadKeygen() {
        if  let keygen = UserDefaults.standard.value(forKey: kPrivateKeygenKey) as? String, keygen.count > 0 {
            Go23Net.uploadServerShard(with: keygen, address: Go23WalletMangager.shared.address) { status in
                if status {
                    UserDefaults.standard.set("", forKey: kPrivateKeygenKey)
                }
            }
        }
        
    }
    
}

extension Go23HomeViewController: Go23ConnectDelegate {
    func setPincodePageWillShow() {
        print("=========setPincodePageWillShow")
        Go23Loading.loading()
    }
    
    func setPincodePageWillDismiss() {
        print("=========setPincodePageWillDismiss")
        Go23Loading.clear()
    }
    
}

extension Go23HomeViewController: Go23ReshardDelegate {
    func reshardWillStart() {
        print("=========reshardWillStart")
        Go23Loading.loading()
    }
    
    func reshardDidEnd() {
        print("=========reshardDidEnd")
        Go23Loading.clear()
    }
}

extension Go23HomeViewController: Go23SetPincodeDelegate {
    func verifyPincodePageWillShow() {
        print("=========verifyPincodePageWillShow")
        Go23Loading.loading()
    }
    
    func verifyPincodePageWillDismiss() {
        print("=========verifyPincodePageWillDismiss")
        Go23Loading.clear()
    }
}

extension Go23HomeViewController {
    private func getOAuthClientInfo(with clientId: String) {
        ArcadeOAuthNetwork.getThirdAccountInfo(with: clientId) { [weak self] (clientInfo, returnMsg) in
            guard let info = clientInfo
            else {
                self?.authFailed(with: returnMsg)
                return
            }
            
            self?.showOAuthAlertView(with: info)
        }
    }
    
    
    private func showOAuthAlertView(with clientInfo: AuthClientInfo) {
        if ArcadeOAuthManager.default.isAuthed() == false {
            showFirstOAuthView(with: clientInfo)
        } else {
            showSecondOAuthView(with: clientInfo)
        }
    }
    
    private func showFirstOAuthView(with clientInfo: AuthClientInfo) {
        isShowAuthed = true
        hasOauth = false
        
        ArcadeOAuthConfirmView.show(appName: clientInfo.clientName) { [weak self] result in
            guard let confirmResult = result as? Bool else {
                self?.cancelAuth()
                return
            }
            
            if confirmResult {
                self?.getOAuthCode()
            } else {
                self?.cancelAuth()
            }
        }
    }
    
    private func showSecondOAuthView(with clientInfo: AuthClientInfo) {
        isShowAuthed = true
        hasOauth = false
        
        ArcadeOAuthedConfirmView.show(appName: clientInfo.clientName) { [weak self] result in
            guard let confirmResult = result as? Bool else {
                self?.cancelAuth()
                return
            }
            
            if confirmResult {
                self?.getOAuthCode()
            } else {
                self?.cancelAuth()
            }
        }
    }
    
    private func getOAuthCode() {
        guard let scope = authScope else {
            self.authFailed(with: "Auth scope is need, please need we konw.")
            return
        }
        
        ArcadeOAuthNetwork.getOAuthCode(with: scope,
                                        clientId: authClientId!,
                                        walletClientId: "1",
                                        walletClientSecret: "40ad7c25",
                                        uniqueId: "4d50bad18537456998a9270ea7eac077") { [weak self] (codeInfo, returnMsg) in
            guard let info = codeInfo
            else {
                self?.authFailed(with: returnMsg)
                return
            }
            
            self?.authSuccess(with: info)
        }
    }
    
    private func cancelAuth() {
        ArcadeOAuthManager.default.cancelAuthCallback()
    }
    
    
    private func authFailed(with msg: String) {
        ArcadeOAuthManager.default.authFailed(with: msg)
    }
    
    private func authSuccess(with model: AuthCodeInfo) {
        ArcadeOAuthManager.default.authCallback(with: model.code)
    }
}

