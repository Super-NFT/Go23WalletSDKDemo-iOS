//
//  Go23TokenDetailTableViewCell.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK

class Go23TokenDetailTableViewCell: UITableViewCell {

    static var cellHeight: CGFloat {
        return 72.0
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
        contentView.addSubview(backView)
        backView.addSubview(coverImgv)
        backView.addSubview(tokenLabel)
        backView.addSubview(timeLabel)
        backView.addSubview(moneyLabel)
        backView.addSubview(dLabel)
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(66)
        }
        
        coverImgv.snp.makeConstraints { make in
            make.left.equalTo(9)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        tokenLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImgv.snp.right).offset(9)
            make.top.equalTo(12)
            make.height.equalTo(22)
            make.width.equalTo(150)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(coverImgv.snp.right).offset(9)
            make.top.equalTo(tokenLabel.snp.bottom).offset(1)
            make.height.equalTo(20)
        }
        
        moneyLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-9)
            make.centerY.equalToSuperview()
//            make.width.equalTo(ScreenWidth-160.0)
            make.left.equalTo(tokenLabel.snp.right).offset(20)
            make.height.equalTo(22)
        }
        
        dLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-9)
            make.centerY.equalTo(timeLabel.snp.centerY)
            make.width.equalTo(170)
            make.height.equalTo(22)
        }
        
    }
    
    func filled(model: Go23ActivityModel) {
        var model = model
        timeLabel.text = model.time
        if model.value.count>12 {
            model.value = model.value.substring(to: 12)+"..."
        }
        if model.status == 3 {
            coverImgv.image = UIImage.init(named: "failed")
            tokenLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#595959"),alignment: .left, title: model.type+" "+String.getSubSecretString(string: model.fromAddr))
            moneyLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .right, title: "-\(model.value) "+model.symbol)
        } else {
            if model.type == "Receive" {
                coverImgv.image = UIImage.init(named: "in")
                tokenLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#595959"),alignment: .left, title: model.type+" "+String.getSubSecretString(string: model.fromAddr))
                moneyLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#00D6E1"),alignment: .right, title: "+\(model.value) "+model.symbol)
//                tokenLabel.text = model.type+" "+String.getSubSecretString(string: model.fromAddr)
//                moneyLabel.text = "+\(model.value) "+model.symbol
//                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#35C1D8")
            } else if model.type == "Send" {
                coverImgv.image = UIImage.init(named: "out")
//                tokenLabel.text = model.type+" "+String.getSubSecretString(string: model.toAddr)
//                moneyLabel.text = "-\(model.value) "+model.symbol
//                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                tokenLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#595959"),alignment: .left, title: model.type+" "+String.getSubSecretString(string: model.toAddr))
                moneyLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .right, title: "-\(model.value) "+model.symbol)
            } else if model.type == "Approve" {
                coverImgv.image = UIImage.init(named: "approve")
//                tokenLabel.text = model.type+" "+String.getSubSecretString(string: model.toAddr)
//                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//                moneyLabel.text = model.value+" "+model.symbol
                tokenLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#595959"),alignment: .left, title: model.type+" "+String.getSubSecretString(string: model.toAddr))
                moneyLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .right, title: "\(model.value) "+model.symbol)
            } else if model.type == "Mint" {
                coverImgv.image = UIImage.init(named: "mint")
//                tokenLabel.text = model.type+" "+String.getSubSecretString(string: model.toAddr)
//                moneyLabel.text = "-\(model.value) "+model.symbol
//                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                tokenLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#595959"),alignment: .left, title: model.type+" "+String.getSubSecretString(string: model.toAddr))
                moneyLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .right, title: "-\(model.value) "+model.symbol)
            }else if model.type == "Swap" {
                coverImgv.image = UIImage.init(named: "mint")
//                tokenLabel.text = model.type+" "+String.getSubSecretString(string: model.toAddr)
//                moneyLabel.text = "-\(model.value) "+model.symbol
//                moneyLabel.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
                tokenLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#595959"),alignment: .left, title: model.type+" "+String.getSubSecretString(string: model.toAddr))
                moneyLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 16), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .right, title: "-\(model.value) "+model.symbol)
            }
        }
        
        if let mm = Double(model.balanceU), mm >= 0 {
            moneyLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-9)
                make.centerY.equalTo(tokenLabel.snp.centerY)
                make.width.equalTo(170)
                make.height.equalTo(22)
            }
            dLabel.isHidden = false
            dLabel.text = "$\(model.balanceU)"
            
            if model.type == "Approve" {
                dLabel.isHidden = true
            }
        } else {
            dLabel.isHidden = true
            moneyLabel.snp.remakeConstraints { make in
                make.trailing.equalTo(-9)
                make.centerY.equalToSuperview()
                make.width.equalTo(170)
                make.height.equalTo(22)
            }
        }
        
        
        
    }
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
//        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
//        view.layer.cornerRadius = 8
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return view
    }()
    
    private lazy var coverImgv: UIImageView = {
        let imgv = UIImageView()
        return imgv
    }()
    
    private lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString:  "#595959")
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 12)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 16)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.textAlignment = .right
        return label
    }()
    
    private lazy var dLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 12)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .right
        return label
    }()
}


