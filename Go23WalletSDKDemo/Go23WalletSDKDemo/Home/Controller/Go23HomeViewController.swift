//
//  Go23HomeViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import UIKit
import Go23SDK

class Go23WalletMangager {
    static let shared = Go23WalletMangager()
    var walletModel: Go23WalletChainModel?
    var address = ""
    var email = ""
    var balance = ""
    var balanceU = ""
    var phone = ""
    
}

extension JXPagingListContainerView: JXSegmentedViewListContainer {}

public class Go23HomeViewController: UIViewController, Go23NetStatusProtocol {
    
    private var email = ""
    
    var userinfo: UserInfoModel?
    var walletList: [Go23WalletInfoModel]?
    var chainList: [Go23WalletChainModel]?
    private var nftList: [Go23WalletNFTModel]?
    
    
    var tokenList: [Go23WalletTokenModel]?
    var tableHeaderViewHeight: Int = Int(HomeHeaderView.cellHight)
    var headerInSectionHeight: Int = 60
    private var list1: Go23TokenListViewController?
    private var list2: Go23NFTListViewController?
    
    private var timer: Timer?
    private var timerProgress: Double = 0.0
    private var isAniLoading = false
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
                
        NotificationCenter.default.addObserver(self, selector: #selector(registerUser), name: NSNotification.Name(rawValue: kRegisterUser), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(registerUser), name: NSNotification.Name(rawValue: kRefreshWalletData), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getChainBalance), name: Notification.Name(rawValue: kRefreshWalletBalance), object: nil)        
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        pagingView.frame = CGRectMake(0, CGFloat(HomeTopView.cellHight), ScreenWidth, ScreenHeight-CGFloat(HomeTopView.cellHight))
    }
    
    private func initSubViews() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(HomeTopView.cellHight)
        }
        segmentedView.frame = CGRectMake(0, 0, ScreenWidth, CGFloat(headerInSectionHeight))
        segmentedView.backgroundColor = .white
        segmentedView.delegate = self
         
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
        segmentedView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
        view.addSubview(pagingView)
        pagingView.mainTableView.gestureDelegate = self
        pagingView.mainTableView.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")
        segmentedView.listContainer = pagingView.listContainerView
        
//        let header = Go23RefreshHeaderAnimator.init(frame: .zero)
//        pagingView.mainTableView.es.addPullToRefresh(animator: header) {[weak self] in
//            self?.list1?.tokenIndex = 1
//            self?.list2?.nftIndex = 1
//            self?.getChainBalance()
//            self?.getUserTokens()
//        }
        
        self.view.addSubview(animationImgv)

    }
    
    // MARK: - Action
    private func popSettingEmail() {
        
        if let kEmail = UserDefaults.standard.string(forKey: kEmailPrivateKey), kEmail.count > 0 {
            return
        }
        
        if  let kSMS = UserDefaults.standard.string(forKey: kPhonePrivateKey), kSMS.count > 0 {
            return
        }
        
        let alert = Go23SettingAccountView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight-120))
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
        
         alert.nftBlock = { [weak self] in
             let aa = Go23AddNFTView(frame: CGRectMake(0, 0, ScreenWidth, 365))
             let oo = OverlayController(view: aa)
             oo.maskStyle = .black(opacity: 0.4)
             oo.layoutPosition = .bottom
             oo.presentationStyle = .fromToBottom
             oo.isDismissOnMaskTouched = false
             oo.isPanGestureEnabled = true
             oo.shouldKeyboardChangeFollow = true
             oo.keyboardRelativeOffset = -200
             aa.closeBlock = {
                 self?.view.dissmiss(overlay: .last)
             }
             self?.view.present(overlay: oo)
         }
         alert.closeBlock = { [weak self] in
             self?.view.dissmiss(overlay: .last)
         }
         self.view.present(overlay: ovc)
    }
    
    
    private lazy var topView: HomeTopView = {
        let view = HomeTopView()
        view.delegate = self
        return view
    }()
    
    private lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: HomeHeaderView.cellHight))
        view.delegate = self
        return view
    }()
    lazy var pagingView: JXPagingView = preferredPagingView()

    let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    
    private lazy var segmentedView: JXSegmentedView = {
        
        let view = JXSegmentedView()
        view.contentEdgeInsetLeft = 30
        view.contentEdgeInsetRight = ScreenWidth - 120
        view.delegate = self
        view.isContentScrollViewClickTransitionAnimationEnabled = false
        
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorCornerRadius = 6.0
        indicator.verticalOffset = 1
        indicator.indicatorColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        indicator.layer.shadowColor = UIColor.black.cgColor
        indicator.layer.shadowOffset = CGSize(width:1, height:1)
        indicator.layer.shadowRadius = 6
        indicator.layer.shadowOpacity = 0.08
        view.indicators = [indicator]
        return view
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
    
    private lazy var animationImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "loading_30")
        imgv.frame = CGRectMake((ScreenWidth-50)/2.0, -50, 40, 40)
        return imgv
    }()
    

}

extension Go23HomeViewController: HomeTopViewDelegate {
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
            self?.view.dissmiss(overlay: .last)
            Go23WalletMangager.shared.walletModel = model
            self?.self.topView.filled(chainName: Go23WalletMangager.shared.walletModel?.name ?? "")
            self?.topView.chooseV.filled(title: model.name, img: model.imageUrl)
            self?.registerUser()
            self?.setDefaultChain(with: model.walletAddress, and: model.chainId)
            
        }
        alert.closeBlock = { [weak self] in
            self?.view.dissmiss(overlay: .last)
        }
        
        self.view.present(overlay: ovc)
    }
    
    func settingBtnClick() {
        self.settingBtnDidClick()
    }
}

extension Go23HomeViewController: HomeHeaderViewDelegate {
    
    
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func eyeBtnClick() {
        list1?.tableView.reloadData()
    }

}

// MARK: - pragma mark =========== JXSegmentedViewDelegate ===========
extension Go23HomeViewController: JXSegmentedViewDelegate {

    func preferredPagingView() -> JXPagingView {
        return JXPagingView(delegate: self)
    }
    
    func pagingView(_ pagingView: JXPagingView, mainTableViewDidScroll scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= HomeHeaderView.cellHight {
            list1?.noDataV.snp.remakeConstraints({ make in
                make.center.equalToSuperview()
            })
            list2?.noDataV.snp.remakeConstraints({ make in
                make.center.equalToSuperview()
            })
        } else {
            list1?.noDataV.snp.remakeConstraints { make in
                make.top.equalTo(180 * Go23_Scale)
                make.centerX.equalToSuperview()
            }
            list2?.noDataV.snp.remakeConstraints { make in
                make.top.equalTo(180 * Go23_Scale)
                make.centerX.equalToSuperview()
            }
        }
        
        animationForHeaderRefresh(offset: scrollView.contentOffset.y)
        headerView.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
    
   
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            if list1 == nil {
                list1 = Go23TokenListViewController()
                list1?.moreDataBlock = { [weak self] ll in
                    self?.tokenList = ll
                }
            }
            list1?.tokenList = tokenList
            return list1!
        } else {
            if list2 == nil {
                list2 = Go23NFTListViewController()
                list2?.moreDataBlock = { [weak self] ll in
                    self?.nftList = ll
                }
            }
            list2?.nftList = nftList
            return list2!
        }
        
    }

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
        if index == 0 {
            list1?.tokenList = tokenList
        } else {
            list2?.nftList = nftList
        }
    }
    
}

extension Go23HomeViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return tableHeaderViewHeight
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return headerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return headerInSectionHeight
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return 2
    }
}

extension Go23HomeViewController: JXPagingMainTableViewGestureDelegate {

    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
    }
}

//SDK
extension Go23HomeViewController {
       
    private func recover(walletlist: [Go23WalletInfoModel]) {
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
        
        var uniqueId = ""
        if let kEmail = UserDefaults.standard.string(forKey: kEmailPrivateKey), kEmail.count > 0 {
            Go23WalletMangager.shared.email = kEmail
            uniqueId = kEmail
        }
        
        if let kSMS = UserDefaults.standard.string(forKey: kPhonePrivateKey), kSMS.count > 0 {
            Go23WalletMangager.shared.phone = kSMS
            uniqueId = kSMS
        }
        
        var phone = ""
        var areaCode = ""
        if Go23WalletMangager.shared.phone.count > 0, Go23WalletMangager.shared.phone.components(separatedBy: " ").count == 2 {
            phone = Go23WalletMangager.shared.phone.components(separatedBy: " ")[1]
            areaCode = Go23WalletMangager.shared.phone.components(separatedBy: " ")[0]
        }
        
        popSettingEmail()
        
        if Go23WalletMangager.shared.email.count == 0 && Go23WalletMangager.shared.phone.count == 0 {
            return
        }
        
        Go23Loading.loading()
        shared.connect(with: uniqueId, email: Go23WalletMangager.shared.email,phone: (areaCode, phone), delegate: self) { [weak self] result in
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
        self.getUserChains(with: wallet.address)
    }
    
    private func getUserChains(with walletAddress: String) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
          
        shared.getCurrentChain(with: walletAddress) { [weak self] model in
            guard let obj = model else {
                Go23Loading.clear()
                return
            }
            Go23WalletMangager.shared.walletModel = obj
            self?.getUserTokens()
            self?.getChainBalance()
            self?.topView.filled(chainName: Go23WalletMangager.shared.walletModel?.name ?? "")
            self?.topView.chooseV.filled(title: obj.name, img: obj.imageUrl)
        }
            

    }
    
    private func getUserTokens() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        shared.getWalletTokenList(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, pageSize: 20, pageNumber: 1) { [weak self]model in
//            self?.pagingView.mainTableView.es.stopPullToRefresh()
            self?.stopAnimating()
            Go23Loading.clear()
            guard let list = model?.listModel else {
                return
            }
            self?.tokenList?.removeAll()
            self?.tokenList = list
            self?.pagingView.reloadData()
            
        }
        getUserNFTs()
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
            
            self?.headerView.filled(money: bal,symbol:  Go23WalletMangager.shared.walletModel?.symbol ?? "",balanceU: balU,address: Go23WalletMangager.shared.address)
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
    public func setPincodePageWillShow() {
        print("=========setPincodePageWillShow")
        Go23Loading.loading()
    }
    
    public func setPincodePageWillDismiss() {
        print("=========setPincodePageWillDismiss")
        Go23Loading.clear()
    }
    
}

extension Go23HomeViewController: Go23ReshardDelegate {
    public func reshardWillStart() {
        print("=========reshardWillStart")
        Go23Loading.loading()
    }
    
    public  func reshardDidEnd() {
        print("=========reshardDidEnd")
        Go23Loading.clear()
    }
}

extension Go23HomeViewController: Go23SetPincodeDelegate {
   public func verifyPincodePageWillShow() {
        print("=========verifyPincodePageWillShow")
        Go23Loading.loading()
    }
    
    public func verifyPincodePageWillDismiss() {
        print("=========verifyPincodePageWillDismiss")
        Go23Loading.clear()
    }
}


extension Go23HomeViewController {
    
    func getUserNFTs() {
       guard let shared = Go23WalletSDK.shared
       else {
           return
       }
       
       shared.getNftList(with: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0, pageSize: 20, pageNumber: 1) {  [weak self]model in
           guard let obj = model else {
               return
           }

           self?.nftList?.removeAll()
           self?.nftList = obj.listModel
           self?.list2?.nftList = self?.nftList
       }
       
   }
    
}


// header refresh animation
extension Go23HomeViewController {
    
    func animationForHeaderRefresh(offset: CGFloat) {
        if offset <= -60.0 && !isAniLoading {
            self.isAniLoading = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.animationImgv.transform = CGAffineTransform(translationX: 0, y: 150)
                self.startAnimating()

            }, completion: { _ in
            })
        }
    }
    
    @objc func timerAction() {
//        timerProgress += 0.01
//        self.animationImgv.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2).inverted().concatenating(self.animationImgv.transform)
    }
    
    func startAnimating() {
        
//        if timer == nil {
//            timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
//            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        var images = [UIImage]()
        for i in 1...16 {
            if let img = UIImage(named: "loading_\(i)") {
                images.append(img)
            }
        }
        animationImgv.animationImages = images
        animationImgv.animationDuration = 0.6
        animationImgv.animationRepeatCount = LONG_MAX
        animationImgv.startAnimating()
            list1?.tokenIndex = 1
            list2?.nftIndex = 1
            getChainBalance()
            getUserTokens()
//        }
    }
    
    func stopAnimating() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            if self.timer != nil {
//                self.timerProgress = 0.0
//                self.timer?.invalidate()
//                self.timer = nil
//            }
            self.animationImgv.stopAnimating()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.animationImgv.transform = .identity

            }, completion: { _ in
                self.isAniLoading = false
            })
        }
        
    }
    
}

