//
//  Go23ChooseAlertView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/5.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import Go23SDK

class Go23ChooseAlertView: UIView {
    
    
    var chainList: [Go23WalletChainModel]? {
        didSet {
            guard let chainList = chainList else {
                return
            }
            self.tableView.reloadData()
        }
    }
    
    var chooseBlock: ((_ model: Go23WalletChainModel)->())?
    override init(frame: CGRect) {
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
        addSubview(tableView)
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
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(14)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func closeBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)

    }
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "close")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(15)
        }
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Choose Mainnets")
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
        
        tableView.register(Go23ChooseAlertViewCell.self, forCellReuseIdentifier: Go23ChooseAlertViewCell.reuseIdentifier())


        return tableView
    }()
}

extension Go23ChooseAlertView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chainList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Go23ChooseAlertViewCell.reuseIdentifier(), for: indexPath) as? Go23ChooseAlertViewCell, let count = self.chainList?.count, indexPath.row < count
        else {
                return UITableViewCell()
            }
            
        if let model = self.chainList?[indexPath.row] {
            cell.filled(cover: model.imageUrl, title:  model.name, isShow: model.hasDefault )

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Go23ChooseAlertViewCell.cellHeight

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        if let list = self.chainList, indexPath.row < list.count {
            self.chooseBlock?(list[indexPath.row])
        }
    }
}


class Go23ChooseAlertViewCell: UITableViewCell {
    static var cellHeight: CGFloat {
        return 60.0
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
        contentView.addSubview(coverImgv)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImgv)
        
        coverImgv.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImgv.snp.right).offset(12)
            make.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        arrowImgv.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
    }
    
    
    func filled(cover: String, title: String, isShow: Bool) {
        coverImgv.sd_setImage(with: URL(string: cover), placeholderImage: nil, completed: nil)

        titleLabel.text = title
        if isShow {
            arrowImgv.isHidden = false
            contentView.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        } else {
            arrowImgv.isHidden = true
            contentView.backgroundColor = .white
        }
    }
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var arrowImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "blueArrow")
        return imgv
    }()
}
