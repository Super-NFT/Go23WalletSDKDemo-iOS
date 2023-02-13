//
//  Go23TokenListTableViewCell.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

import Kingfisher
import UIKit

class Go23TokenListTableViewCell: UITableViewCell {

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
        contentView.addSubview(tokenTypeLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(titleMonLabel)
        contentView.addSubview(sourceImgv)
        
        iconImgv.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(35)
        }
        
        sourceImgv.snp.makeConstraints { make in
            make.bottom.equalTo(iconImgv.snp.bottom).offset(0)
            make.right.equalTo(iconImgv.snp.right).offset(0)
            make.height.width.equalTo(14)
        }
        titleLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(8)
            make.height.equalTo(24)
        }
        
        tokenTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImgv.snp.right).offset(14)
            make.top.equalTo(8)
            make.height.equalTo(24)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImgv.snp.right).offset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.height.equalTo(18)
        }
        
        titleMonLabel.snp.makeConstraints { make in
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.height.equalTo(18)
        }
        
    }
    
    func filled(cover: String, title: String, type: String, money: String, sourceImg: String, value: String) {
        iconImgv.kf.setImage(with: URL(string: cover))
        if Float(title) ?? 0.0 > 0 {
            titleLabel.text = title
        } else {
            titleLabel.text = "0.00"
        }
        tokenTypeLabel.text = type
        moneyLabel.text = "$0.00"
        if Float(value) ?? 0.0 > 0 {
            moneyLabel.text = "$\(value)"
        }
        titleMonLabel.text = "$0.00"
        if Float(money) ?? 0.0 > 0 {
            titleMonLabel.text = "$\(money)"
        }
        if UserDefaults.standard.bool(forKey: kEyeBtnKey) {
            titleLabel.text = "****"
            titleMonLabel.text = "****"
        }
        sourceImgv.kf.setImage(with: URL(string: sourceImg))
    }
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        label.text = "0.00"
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var titleMonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.text = "$0.00"
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var tokenTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "$0.00"
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var sourceImgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
}
