//
//  Go23ReshardingView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK
import Client

public enum SettingType: Int {
    case resharding
    case recover
}

class Go23ReshardingView: UIView {
    
    private var settingType: SettingType
    private var isShowBack = true
    init(frame: CGRect, type: SettingType = .resharding, isShow: Bool = true) {
        isShowBack = isShow
        self.settingType = type
        super.init(frame: frame)
        initSubviews()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(closeBtn)
        if !isShowBack {
            closeBtn.isHidden = true
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        closeBtn.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.width.height.equalTo(44)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        addSubview(segmentedView)
        addSubview(listContainerView)
        segmentedView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        segmentedView.delegate = self
        segmentedView.listContainer = listContainerView
        
        
        dataSource.titles = ["Email"]
        dataSource.titleNormalFont = UIFont(name: BarlowCondensed, size: 16)!
        dataSource.titleSelectedFont = UIFont(name: BarlowCondensed, size: 16)!
//        dataSource.titleSelectedColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//        dataSource.titleNormalColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        dataSource.titleSelectedColor = UIColor.clear
        dataSource.titleNormalColor = UIColor.clear
        
        segmentedView.dataSource = dataSource
        segmentedView.reloadData()
    }
    
    @objc private func closeBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        
    }
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "back")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Verify")
        return label
    }()
    
    let dataSource: JXSegmentedTitleDataSource = JXSegmentedTitleDataSource()
    
    private lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    private lazy var segmentedView: JXSegmentedView = {
        
        let segmentedView = JXSegmentedView()
        segmentedView.contentEdgeInsetLeft = 20
        segmentedView.contentEdgeInsetRight = ScreenWidth - 80
        segmentedView.delegate = self
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        return segmentedView
    }()
    
}

// MARK: - pragma mark =========== JXSegmentedViewDelegate ===========

extension Go23ReshardingView: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
            segmentedView.dataSource = dataSource
            segmentedView.reloadItem(at: index)
//        }
    }
}

// MARK: - pragma mark =========== JXSegmentedListContainerViewDataSource ===========
extension Go23ReshardingView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = Go23EmailViewController()
        vc.settingType = settingType
        vc.filled()
        return vc
        
    }
    
}
