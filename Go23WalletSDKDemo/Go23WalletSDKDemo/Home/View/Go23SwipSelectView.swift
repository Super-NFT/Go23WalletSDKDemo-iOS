//
//  Go23SwipSelectView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/2/21.
//

import UIKit
import Go23SDK
import Kingfisher

class Go23SwipSelectView: UIView {

    var tokenList: [Go23WalletTokenModel]?
    private var tokenIndex = 1
    
    var clickBlock: ((_ model: Go23WalletTokenModel)->())?
    
    var addBtnBlock:(()->())?
    
    var closeBlock:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
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
        
        

        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-6)
            make.width.height.equalTo(44)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        
        //        addSubview(addBtn)
//        addBtn.snp.makeConstraints { make in
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(0)
//             } else {
//                 make.bottom.equalTo(0)
//            }
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.height.equalTo(52)
//        }
        
    }
   
    @objc private func closeBtnClick() {
        self.closeBlock?()
        
    }
    
    @objc private func addBtnClick() {
        addBtnBlock?()
    }
        
    private lazy var closeBtn: UIButton = {
            let btn = UIButton(type: .custom)
            let imgv = UIImageView()
            imgv.image = UIImage.init(named: "close")
            btn.addSubview(imgv)
            imgv.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(13)
                make.width.equalTo(13)
            }
            btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
            return btn
        }()
        
    private lazy var titleLabel: UILabel = {
            let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Select a token to send")
            return label
        }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setAttributedTitle(String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 24), wordspace: 0.5, color: UIColor.white, alignment: .center, title: "Add a token"), for: .normal)
        btn.addTarget(self, action: #selector(addBtnClick), for: .touchUpInside)
        return btn
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
   
    }

// MARK: - pragma mark =========== JXSegmentedViewDelegate ===========

extension Go23SwipSelectView: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
            segmentedView.dataSource = dataSource
            segmentedView.reloadItem(at: index)
    }
}

// MARK: - pragma mark =========== JXSegmentedListContainerViewDataSource ===========
extension Go23SwipSelectView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
  
        let vc = Go23SwapSelectViewController()
        return vc


    }
    
}
    
