//
//  Go23TokenListTableViewCell.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/4.
//

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
        contentView.addSubview(arrowImgv)
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
            make.left.equalTo(iconImgv.snp.right).offset(14)
            make.top.equalTo(8)
            make.height.equalTo(24)
        }
        
        tokenTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(4)
            make.top.equalTo(8)
            make.height.equalTo(24)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImgv.snp.right).offset(14)
            make.top.equalTo(titleLabel.snp.bottom).offset(1)
            make.height.equalTo(18)
        }
        
        arrowImgv.snp.makeConstraints { make in
            make.trailing.equalTo(-20)
            make.height.equalTo(13)
            make.width.equalTo(13)
            make.centerY.equalToSuperview()
        }
    }
    
    func filled(cover: String, title: String, type: String, money: String, sourceImg: String) {
        iconImgv.sd_setImage(with: URL(string: cover), placeholderImage: nil)
        titleLabel.text = title
        tokenTypeLabel.text = type
         if let mon = Double(money), mon <= 0 {
            moneyLabel.isHidden = true
             titleLabel.snp.remakeConstraints { make in
                 make.left.equalTo(iconImgv.snp.right).offset(14)
                 make.centerY.equalToSuperview()
                 make.height.equalTo(24)
             }
             tokenTypeLabel.snp.remakeConstraints { make in
                 make.left.equalTo(titleLabel.snp.right).offset(4)
                 make.centerY.equalToSuperview()
                 make.height.equalTo(24)
             }
        } else {
            moneyLabel.isHidden = false
            titleLabel.snp.remakeConstraints { make in
                make.left.equalTo(iconImgv.snp.right).offset(14)
                make.top.equalTo(8)
                make.height.equalTo(24)
            }
            tokenTypeLabel.snp.remakeConstraints { make in
                make.left.equalTo(titleLabel.snp.right).offset(4)
                make.top.equalTo(8)
                make.height.equalTo(24)
            }
        }
        moneyLabel.text = "$ \(money)"
        sourceImgv.sd_setImage(with: URL(string: sourceImg), placeholderImage: nil)
    }
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        
        return imgv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 16)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var tokenTypeLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 16)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: BarlowCondensed, size: 14)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var arrowImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "rightArrow")
        return imgv
    }()
    
    private lazy var sourceImgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
}
