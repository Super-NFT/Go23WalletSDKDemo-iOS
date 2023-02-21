//
//  Go23TokenDetailViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK

class Go23TokenDetailViewController: UIViewController {

    
    var model: Go23WalletTokenModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.headerView.filled(cover: model.imageUrl, type: model.symbol, name: Go23WalletMangager.shared.walletModel?.name ?? "", num: model.balance, money: model.balanceU, sourceImg: model.chainImageUrl)
            
        }
    }
        
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
        setNav()
        initSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(getDetail), name: Notification.Name(rawValue: kRefreshTokenListDetailKey), object: nil)
        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setNav() {
        
        let backBtn = UIButton()
        backBtn.frame = CGRectMake(0, 0, 44, 44)
        let imgv = UIImageView()
        backBtn.addSubview(imgv)
        imgv.image = UIImage.init(named: "back")
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        backBtn.addTarget(self, action: #selector(backBtnDidClick), for: .touchUpInside)
        
        if self.navgationBar == nil {
            addBarView()
            navgationBar?.leftBarItem = HBarItem.init(customView: backBtn)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func initSubviews() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Go23TokenHeaderView.cellHeight)
        }
        
        view.addSubview(segmentedView)
        segmentedView.addSubview(lineV)
        view.addSubview(listContainerView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        lineV.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        
        
        dataSource.titles = ["All", "Out", "In", "Failed"]
        dataSource.titleNormalFont = UIFont(name: BarlowCondensed, size: 16)!
        dataSource.titleSelectedFont = UIFont(name: BarlowCondensed, size: 16)!
        dataSource.titleSelectedColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        dataSource.titleNormalColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        dataSource.kern = 1
        dataSource.widthForTitleClosure = { _ in
            return 50
        }
        segmentedView.dataSource = dataSource
        segmentedView.reloadData()
        
    }
    
    private lazy var headerView: Go23TokenHeaderView = {
        let view = Go23TokenHeaderView()
        view.delegate = self
        return view
    }()
    
    let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    private lazy var segmentedView: JXSegmentedView = {
        
        let segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")

        segmentedView.delegate = self
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 50
        indicator.indicatorHeight = 3
        indicator.verticalOffset = 1
        indicator.indicatorColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        segmentedView.indicators = [indicator]
        
        return segmentedView
    }()
    
    private lazy var lineV: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return view
    }()

}

extension Go23TokenDetailViewController: TokenHeaderViewDelegate {
    func receiveBtnClick() {
        let alert = Go23ReceiveView(frame: CGRectMake(0, 0, 332, Go23ReceiveView.cellHeight))
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .center
        ovc.presentationStyle = .fade
        ovc.isDismissOnMaskTouched = true
        ovc.isPanGestureEnabled = true
        alert.filled(title: self.model?.name ?? "", qrcode: Go23WalletMangager.shared.address)
        UIApplication.shared.keyWindow?.present(overlay: ovc)
        
    }
    func sendBtnClick() {
        let vc = Go23SendViewController()
        vc.filled(cover: self.model?.imageUrl ?? "", name: self.model?.name ?? "", chainId: self.model?.chainId ?? 0,symbol: self.model?.symbol ?? "", contract: self.model?.contractAddr ?? "")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func leftBtnClick() {
        backBtnDidClick()
    }
    
    func swapBtnClick() {
        let vc = Go23SwapViewController()
        vc.tokenModel = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - pragma mark =========== JXSegmentedViewDelegate ===========

extension Go23TokenDetailViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self.segmentedView.selectedIndex == 0)
            segmentedView.dataSource = dataSource
            segmentedView.reloadItem(at: index)
    }
}

// MARK: - pragma mark =========== JXSegmentedListContainerViewDataSource ===========
extension Go23TokenDetailViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
  
        
        if index == 0 {
            let vc = Go23TokenDetailListViewController()
            vc.model = self.model
            vc.activityType = .all
            return vc

        } else if index == 1 {
            let vc = Go23TokenDetailListViewController()
            vc.model = self.model
            vc.activityType = .outcome
            return vc

        } else if index == 2{
            let vc = Go23TokenDetailListViewController()
            vc.model = self.model
            vc.activityType = .income
            return vc

        } else {
            let vc = Go23TokenDetailListViewController()
            vc.model = self.model
            vc.activityType = .fail
            return vc

        }

    }
    
}


extension Go23TokenDetailViewController {
    @objc private func getDetail() {
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        guard let obj = self.model else {
            return
        }
        shared.getTokenDetail(for: obj.chainId, tokenAddress: obj.contractAddr) { [weak self] detailModel in
            guard let detailObj = detailModel else {
                return
            }
            self?.headerView.filled(cover: detailObj.imageUrl, type: detailObj.symbol, name: Go23WalletMangager.shared.walletModel?.name ?? "", num: detailObj.balance, money: detailObj.balanceU, sourceImg: detailObj.chainImageUrl)
        }
    }
}
