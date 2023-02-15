//
//  Go23ConfirmTransferView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/8.
//

import UIKit

class Go23ConfirmTransferView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
        filled(cover: "", sign: "0.001 MATIC" , contract: "0x238Ce18d6Dcd3903d72D4BeF550dFd428B235744", from: "0x238Ce18d6Dcd3903d72D4BeF550dFd428B235744", to: "0x238Ce18d6Dcd3903d72D4BeF550dFd428B235744", token: "30323", value: 0.000567, gas: 0.000567, money: 0.000567, type: "BTC")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(iconImgv)
        addSubview(signLabel)
        addSubview(contractTxt)
        addSubview(contractLabel)
        addSubview(fromTxt)
        addSubview(fromLabel)
        addSubview(toTxt)
        addSubview(toLabel)
        addSubview(tokenTxt)
        addSubview(tokenLabel)
        addSubview(valueTxt)
        addSubview(valueLabel)
        addSubview(gasTxt)
        addSubview(gasLabel)
        addSubview(moneyLabel)
        addSubview(cancelBtn)
        addSubview(signBtn)
        
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
        iconImgv.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        signLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImgv.snp.bottom).offset(6)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        contractTxt.snp.makeConstraints { make in
            make.top.equalTo(signLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.height.equalTo(17)
        }
        contractLabel.snp.makeConstraints { make in
            make.leading.equalTo(110)
            make.top.equalTo(signLabel.snp.bottom).offset(20)
            make.trailing.equalTo(-20)
        }
        fromTxt.snp.makeConstraints { make in
            make.top.equalTo(contractTxt.snp.bottom).offset(38)
            make.leading.equalTo(20)
            make.height.equalTo(17)
        }
        fromLabel.snp.makeConstraints { make in
            make.top.equalTo(contractTxt.snp.bottom).offset(38)
            make.leading.equalTo(110)
            make.trailing.equalTo(-20)
        }
        toTxt.snp.makeConstraints { make in
            make.top.equalTo(fromTxt.snp.bottom).offset(38)
            make.leading.equalTo(20)
            make.height.equalTo(17)
        }
        toLabel.snp.makeConstraints { make in
            make.top.equalTo(fromTxt.snp.bottom).offset(38)
            make.leading.equalTo(110)
            make.trailing.equalTo(-20)
        }
        tokenTxt.snp.makeConstraints { make in
            make.top.equalTo(toTxt.snp.bottom).offset(38)
            make.leading.equalTo(20)
            make.height.equalTo(17)
        }
        tokenLabel.snp.makeConstraints { make in
            make.top.equalTo(toTxt.snp.bottom).offset(38)
            make.leading.equalTo(110)
            make.trailing.equalTo(-20)
        }
        valueTxt.snp.makeConstraints { make in
            make.top.equalTo(tokenTxt.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.height.equalTo(17)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(tokenTxt.snp.bottom).offset(20)
            make.leading.equalTo(110)
            make.trailing.equalTo(-20)
        }
        gasTxt.snp.makeConstraints { make in
            make.top.equalTo(valueTxt.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.height.equalTo(17)
        }
        gasLabel.snp.makeConstraints { make in
            make.top.equalTo(valueTxt.snp.bottom).offset(20)
            make.leading.equalTo(110)
            make.trailing.equalTo(-20)
        }
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(gasLabel.snp.bottom).offset(0)
            make.leading.equalTo(110)
            make.trailing.equalTo(-20)
            make.height.equalTo(17)
        }
        cancelBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(150)
            make.leading.equalTo(20)
            make.height.equalTo(46)
        }
        signBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.width.equalTo(150)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        
    }
    
    func filled(cover: String, sign: String, contract: String, from: String, to: String, token: String, value: Float, gas: Float, money: Float, type: String) {
        iconImgv.backgroundColor = .red
        signLabel.text = sign
        contractLabel.text = contract
        fromLabel.text = from
        toLabel.text = to
        tokenLabel.text = token
        valueLabel.text = "\(value)"+type
        gasLabel.text = "\(gas)"+type
        moneyLabel.text = "$\(money)"
    }
    
    
    @objc private func closeBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        
    }
    
    @objc private func signBtnClick() {
        //failed use Go23NFTStatusView
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)

    }
    
    @objc private func cancelBtnClick() {
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Transfer"
        label.font = UIFont.init(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var iconImgv: UIImageView = {
        let imgv = UIImageView()
        imgv.layer.cornerRadius = 20
        return imgv
    }()
    
    private lazy var signLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 40)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#000000")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contractTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Contract:"
        return label
    }()
    
    private lazy var contractLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        label.numberOfLines = 2
        return label
    }()
    private lazy var fromTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "From"
        return label
    }()
    private lazy var fromLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        label.numberOfLines = 2
        return label
    }()
    private lazy var toTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "To"
        return label
    }()
    private lazy var toLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        label.numberOfLines = 2
        return label
    }()
    private lazy var tokenTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "TokenID"
        return label
    }()
    private lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        return label
    }()
    private lazy var valueTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Value"
        return label
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        return label
    }()
    private lazy var gasTxt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.text = "Gas Fee"
        return label
    }()
    private lazy var gasLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#595959")
        return label
    }()
    
    private lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    private lazy var signBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Confirm", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(signBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#f7f7f7")
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }()

}
