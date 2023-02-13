//
//  Go23AddTokenViewController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/5.
//

import UIKit
import Kingfisher
import Go23SDK


class Go23AddTokenViewController: UIViewController {

    
    var tokenList: [Go23ChainTokenModel]?

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
        view.backgroundColor = .white
        setNav()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navgationBar!.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        getUserTokens()
        NotificationCenter.default.addObserver(self, selector: #selector(getUserTokens), name: NSNotification.Name(rawValue: kRefreshWalletData), object: nil)


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
            navgationBar?.title = "Add a Token"
            navgationBar?.attributes = [NSAttributedString.Key.font: UIFont(name: BarlowCondensed, size: 20), NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]
            navgationBar?.leftBarItem = HBarItem.init(customView: backBtn)
        }
    }
    
    @objc private func backBtnDidClick() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = headerView
        tableView.register(AddTokenViewCell.self, forCellReuseIdentifier: AddTokenViewCell.reuseIdentifier())

        return tableView
    }()
    
    private lazy var headerView: AddTokenHeaderView = {
        let view = AddTokenHeaderView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: AddTokenHeaderView.cellHeight))
        view.headerBlock = { [weak self] in
            let vc = Go23AddCustomTokenViewController()
            vc.chainId = Go23WalletMangager.shared.walletModel?.chainId ?? 0
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        return view
    }()

}


extension Go23AddTokenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tokenList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTokenViewCell.reuseIdentifier(), for: indexPath) as? AddTokenViewCell, let count = self.tokenList?.count,indexPath.row < count
        else {
            return UITableViewCell()
        }
        
        if let model = self.tokenList?[indexPath.row] {
            cell.filled(model: model, isHidden: indexPath.row == 0)
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
//
            if model.isPlatform {
                return
            }
            
            if model.isSelected {
                hideToken(model: model)
                return
            }
            addToken(model: model)
            
        }
    }
    
    func postNoti() {
        NotificationCenter.default.post(name: NSNotification.Name(kRefreshWalletData),
                                        object: nil,
                                        userInfo: nil)
    }
}
    
    
    class AddTokenHeaderView: UIView {
        
        var headerBlock: (()->())?
        
        static var cellHeight: CGFloat {
            return 50.0
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            initSubviews()
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initSubviews() {
            addSubview(titleLabel)
            addSubview(arrowImgv)
            addSubview(lineV)
            addSubview(control)
            
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(20)
                make.height.equalTo(24)
            }
            
            arrowImgv.snp.makeConstraints { make in
                make.trailing.equalTo(-20)
                make.height.equalTo(13)
                make.width.equalTo(13)
                make.centerY.equalToSuperview()
            }
            
            lineV.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalTo(0)
                make.height.equalTo(1)
            }
            
            control.snp.makeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        
        @objc private func controlClick() {
            self.headerBlock?()
        }
        
        private lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Add Custom Token"
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
            return label
        }()
        
        private lazy var arrowImgv: UIImageView = {
            let imgv = UIImageView()
            imgv.image = UIImage.init(named: "rightArrow")
            return imgv
        }()
        
        private lazy var lineV: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#f5f5f5")
            return view
        }()
        
        
        private lazy var control: UIControl = {
            let control = UIControl()
            control.addTarget(self, action: #selector(controlClick), for: .touchUpInside)
            return control
        }()
        
    }
    
    class AddTokenViewCell: UITableViewCell {
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
            contentView.addSubview(arrowImgv)
            
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
                make.trailing.equalTo(-50)
                make.top.equalTo(9)
                make.height.equalTo(24)
            }
            
            moneyLabel.snp.makeConstraints { make in
                make.trailing.equalTo(-50)
                make.top.equalTo(numLabel.snp.bottom).offset(0)
                make.height.equalTo(18)
                
            }
            
            arrowImgv.snp.makeConstraints { make in
                make.trailing.equalTo(-20)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(16)
            }
        }
        
        func filled(model: Go23ChainTokenModel, isHidden: Bool) {
            iconImgv.kf.setImage(with: URL(string: model.imageUrl))
            titleLabel.text = model.symbol
            if model.isSelected {
                arrowImgv.image = UIImage.init(named: "blueSel")
            } else {
                arrowImgv.image = UIImage.init(named: "graySel")
            }
            numLabel.text = "0.00"
            moneyLabel.text = "$0.00"
            if Float(model.balance) ?? 0.0 > 0 {
                numLabel.text = model.balance
            }
            if Float(model.balanceU) ?? 0.0 > 0 {
                moneyLabel.text = "$\(model.balanceU)"
            }
            
            if isHidden {
                arrowImgv.isHidden = true
                contractLabel.text = model.chainName
            } else {
                arrowImgv.isHidden = false
                contractLabel.text = String.getSubSecretString(8,string: model.contractAddress)
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
        
        private lazy var arrowImgv: UIImageView = {
            let imgv = UIImageView()
            
            return imgv
        }()
    }


extension Go23AddTokenViewController {
   @objc private func getUserTokens() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
       guard let walletObj = Go23WalletMangager.shared.walletModel else {
           return
           
       }

       Go23Loading.loading()
       shared.getChainTokenList(with: walletObj.chainId, pageSize: 10, pageNumber: 1) { [weak self] model in
           Go23Loading.clear()
           self?.tokenList?.removeAll()
           self?.tokenList = model?.listModel
           self?.tableView.reloadData()
       }
        
    }
    
    func hideToken(model: Go23ChainTokenModel) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        Go23Loading.loading()
        guard let walletObj = Go23WalletMangager.shared.walletModel else {
        return
        }
        shared.hideToken(with: model.chainId, walletAddress: Go23WalletMangager.shared.address, contractAddress: model.contractAddress) { [weak self](data) in
            print(data)
            Go23Loading.clear()
            self?.postNoti()
            self?.getUserTokens()
        }
        

    }
    
    func addToken(model: Go23ChainTokenModel) {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        Go23Loading.loading()
        shared.addToken(with: model.chainId, walletAddress: Go23WalletMangager.shared.address, contractAddress: model.contractAddress) { [weak self](data) in
            Go23Loading.clear()
            self?.postNoti()
            self?.getUserTokens()
        }
        
    }
}
