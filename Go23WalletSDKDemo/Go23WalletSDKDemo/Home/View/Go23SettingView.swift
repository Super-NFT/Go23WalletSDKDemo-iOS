//
//  Go23SettingView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK

class Go23SettingView: UIView {

    var dataArray: [String] = ["Reshard Private Key", "Remove Email"]
    var email = ""
    var pk = ""
    var cancelBlock: (()->())?
    var reshardingBlock: ((_ pk: String)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        getKeygen()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(tableView)

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
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func closeBtnClick() {
        self.cancelBlock?()
    }
    
    lazy var closeBtn: UIButton = {
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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Setting")
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingViewCell.self, forCellReuseIdentifier: SettingViewCell.reuseIdentifier())

        return tableView
    }()
}


extension Go23SettingView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.reuseIdentifier(), for: indexPath) as? SettingViewCell,
                  indexPath.row < self.dataArray.count
        else {
                return UITableViewCell()
            }
            
    
        cell.filled(title: self.dataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Go23ChooseAlertViewCell.cellHeight

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let shared = Go23WalletSDK.shared, self.pk.count > 0 else {
            return
        }
        if indexPath.row == 0 {
            self.reshardingBlock?(self.pk)
        } else {
            UserDefaults.standard.set("", forKey: kEmailPrivateKey)
            let totast = Go23Toast.init(frame: .zero)
            totast.show("Remove email success!", after: 1)
        }
         
    
    }
}

extension Go23SettingView {
    private func getKeygen() {
        Go23Net.getServerShard(with: Go23WalletMangager.shared.address) { [weak self] str in
            if let obj = str {
                self?.pk = obj
            }
            
        }
    }
}

class SettingViewCell: UITableViewCell {
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImgv)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        arrowImgv.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.height.equalTo(13)
            make.width.equalTo(13)
            make.centerY.equalToSuperview()
        }
    }
    
    func filled(title: String) {
        titleLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .left, title: title)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var arrowImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "rightArrow")
        return imgv
    }()
}
