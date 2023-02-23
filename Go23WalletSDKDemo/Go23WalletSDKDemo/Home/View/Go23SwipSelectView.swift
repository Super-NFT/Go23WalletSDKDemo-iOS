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
    
    
    var fromName = ""
    var toName = ""
    var chainName = ""
    var chainList: [Go23WalletChainModel]?
    
    var tokenList: [Go23WalletTokenModel]?
    private var tokenIndex = 1
    private var chainId = -1
    
    var preName = ""
    var clickBlock: ((_ model: Go23WalletTokenModel,_ chainName: String)->())?
    
    var addBtnBlock:(()->())?
    
    var closeBlock:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        initSubviews()
        getUserChains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(closeBtn)
        
        addSubview(tagsView)
        tagsView.tagsViewDelegate = self
        tagsView.tagsViewContentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        tagsView.minimumLineSpacing = 10
        tagsView.minimumInteritemSpacing = 10
        
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
        
        tagsView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().offset(0)
        }
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(tagsView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        getUserTokens()
        
        tableView.es.addPullToRefresh {[weak self] in
            self?.tokenIndex = 1
            self?.getUserTokens(isLoading: false)
        }
        tableView.es.addInfiniteScrolling { [weak self] in
            self?.tokenIndex += 1
            self?.getUserTokens(isLoading: false)
        }
        
//        addSubview(addBtn)
//        addBtn.snp.makeConstraints { make in
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(0)
//            } else {
//                make.bottom.equalTo(0)
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
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Select a token")
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
    
    private lazy var tagsView: Go23TagsView = {
        let view = Go23TagsView()
        view.backgroundColor = .white
        return view
    }()
    
    private var modelDataSource: [TagsPropertyModel] = [TagsPropertyModel]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SwapTokenViewCell.self, forCellReuseIdentifier: SwapTokenViewCell.reuseIdentifier())
        
        return tableView
    }()
    
}
extension Go23SwipSelectView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokenList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SwapTokenViewCell.reuseIdentifier(), for: indexPath) as? SwapTokenViewCell, let count = self.tokenList?.count,indexPath.row < count
        else {
            return UITableViewCell()
        }
        
        if let model = self.tokenList?[indexPath.row] {
            var isHidden = false
            if model.name == fromName || model.name == toName {
                isHidden = true
                if preName != chainName, fromName == toName {
                    isHidden = false
                }
            }
            if indexPath.row == 0 {
                isHidden = true
            }
            
            cell.filled(model: model, isHidden: isHidden)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Go23ChooseAlertViewCell.cellHeight
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let count = self.tokenList?.count, indexPath.row < count {
            
        }
        
        if let count = self.tokenList?.count, indexPath.row < count,let model = self.tokenList?[indexPath.row]{
            if indexPath.row == 0 {
                return
            }
            
            self.clickBlock?(model, chainName)
        }
    }
    
}



extension Go23SwipSelectView: Go23TagsViewProtocol {
    
    func tagsViewUpdatePropertyModel(_ tagsView: Go23TagsView, item: TagsPropertyModel, index: NSInteger) {

    }
    
    func tagsViewItemTapAction(_ tagsView: Go23TagsView, item: TagsPropertyModel, index: NSInteger) {
        if let name = self.chainList?[index].name  {
            self.modelDataSource.removeAll()
            self.chainName = name
            var dataSoures = [TagsPropertyModel]()
            if let list = self.chainList {
                for obj in list {
                    let model = TagsPropertyModel()
                    model.titleLabel.text = obj.name
                    model.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    model.titleLabel.font = UIFont.systemFont(ofSize: 14)
                    model.titleLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                    model.contentView.layer.cornerRadius = 6
                    if obj.name == name {
                        model.contentView.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
                        model.titleLabel.textColor = UIColor.white
                        model.isSelected = true
                        self.chainId = obj.chainId
                        model.contentView.layer.borderWidth = 0
                        model.contentView.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#262626").cgColor
                    } else {
                        model.contentView.backgroundColor = .white
                        model.titleLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                        model.isSelected = false
                        model.contentView.layer.borderWidth = 1
                        model.contentView.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#f0f0f0").cgColor
                    }
                    dataSoures.append(model)
                }
            }
            self.modelDataSource = dataSoures
            self.tagsView.modelDataSource = modelDataSource
            self.tagsView.reloadData()
            self.tagsView.scrollView.setContentOffset(CGPointMake(self.tagsView.currentOffent.width, 0.0), animated: false)
            if chainId > -1 {
                tokenIndex = 1
                getUserTokens()
            }
        }
        
        
    }
    
    func tagsViewTapAction(_ tagsView: Go23TagsView) {
    }
}
    

extension Go23SwipSelectView {
    private func getUserChains() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        shared.fetchWalletChainlist(with:  Go23WalletMangager.shared.address, pageSize: 0, pageNumber: 1) { [weak self] chainModel in
            self?.chainList?.removeAll()
            self?.chainList = chainModel?.listModel
            
            var dataSoures = [TagsPropertyModel]()
            
            if let list = chainModel?.listModel {
                for obj in list {
                    let model = TagsPropertyModel()
                    model.titleLabel.text = obj.name
                    model.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    model.titleLabel.font = UIFont.systemFont(ofSize: 14)
                    model.contentView.layer.cornerRadius = 6
                    model.contentView.layer.borderWidth = 1
                    if obj.name == self?.chainName {
                        self?.chainId = obj.chainId
                        model.isSelected = true
                        model.contentView.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
                        model.titleLabel.textColor = UIColor.white
                        model.contentView.layer.borderWidth = 0
                        model.contentView.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#262626").cgColor
                    } else {
                        model.contentView.backgroundColor = .white
                        model.titleLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                        model.isSelected = false
                        model.contentView.layer.borderWidth = 1
                        model.contentView.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#f0f0f0").cgColor
                    }
                    dataSoures.append(model)
                }
            }
            self?.modelDataSource = dataSoures
            self?.tagsView.modelDataSource = dataSoures
            self?.tagsView.showLine = 1
            self?.tagsView.scrollDirection = .horizontal
            self?.tagsView.reloadData()
            self?.tagsView.scrollView.setContentOffset(CGPointMake(self?.tagsView.currentOffent.width ?? 0.0, 0.0), animated: false)
            self?.getUserTokens()
        }
    }
    
    @objc private func getUserTokens(isLoading: Bool = true) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }

        if isLoading {
            Go23Loading.loading()
        }
        
        shared.getWalletTokenList(with: Go23WalletMangager.shared.address, chainId: self.chainId, pageSize: 20, pageNumber: self.tokenIndex) { [weak self]tokenList in
            self?.tableView.es.stopPullToRefresh()
            self?.tableView.es.stopLoadingMore()
            if isLoading {
                Go23Loading.clear()
            }
           guard let list = tokenList?.listModel else {
               return
           }
           
            if self?.tokenIndex ?? 1 == 1 {
                self?.tokenList?.removeAll()
                self?.tokenList = list
            } else {
                if let _ = self?.tokenList {
                    self?.tokenList! += list
                }
            }

           self?.tableView.reloadData()
       }
        
    }
}




class SwapTokenViewCell: UITableViewCell {
        static var cellHeight: CGFloat {
            return 60.0
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            initSubviews()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initSubviews() {
            contentView.backgroundColor = .white
            contentView.addSubview(iconImgv)
            contentView.addSubview(titleLabel)
            contentView.addSubview(contractLabel)
            contentView.addSubview(numLabel)
            contentView.addSubview(moneyLabel)
            
            iconImgv.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(20)
                make.width.height.equalTo(28)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(9)
                make.left.equalTo(iconImgv.snp.right).offset(12)
                make.height.equalTo(24)
            }
            
            contractLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(0)
                make.left.equalTo(iconImgv.snp.right).offset(12)
                make.height.equalTo(18)
            }
            
            numLabel.snp.makeConstraints { make in
                make.trailing.equalTo(-20)
                make.top.equalTo(9)
                make.height.equalTo(24)
            }
            
            moneyLabel.snp.makeConstraints { make in
                make.trailing.equalTo(-20)
                make.top.equalTo(numLabel.snp.bottom).offset(0)
                make.height.equalTo(18)
                
            }
        }
        
        func filled(model: Go23WalletTokenModel, isHidden: Bool) {
            iconImgv.kf.setImage(with: URL(string: model.imageUrl))
            titleLabel.text = model.symbol
            numLabel.text = "0.00"
            moneyLabel.text = "$0.00"
            if Float(model.balance) ?? 0.0 > 0 {
                numLabel.text = model.balance
            }
            if Float(model.balanceU) ?? 0.0 > 0 {
                moneyLabel.text = "$\(model.balanceU)"
            }
            
            if isHidden {
                titleLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
                numLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
                contractLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#BFBFBF")
                contractLabel.text = model.name
            } else {
                titleLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                numLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
                contractLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
                contractLabel.text = String.getSubSecretString(8,string: model.contractAddr)
            }
        }
        
        private lazy var iconImgv: UIImageView = {
            let imgv = UIImageView()
            
            return imgv
        }()
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
            return label
        }()
        
        private lazy var numLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .right
            label.text = "0.00"
            label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
            return label
        }()
        
        private lazy var contractLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
            return label
        }()
        
        private lazy var moneyLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .right
            label.text = "$0.00"
            label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
            return label
        }()
        
    }
