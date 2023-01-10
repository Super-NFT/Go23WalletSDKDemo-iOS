//
//  Go23AddNFTView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/5.
//

import UIKit
import SnapKit
import IQKeyboardManager
import MBProgressHUD
import Go23WalletSDK

class Go23AddNFTView: UIView {
    
    private var hud: MBProgressHUD?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
        
        IQKeyboardManager.shared().keyboardDistanceFromTextField = 100
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)
        
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(nftsLabel)
        addSubview(nftsTxtFiled)
//        addSubview(tokenLabel)
//        addSubview(tokenTxtFiled)
        addSubview(importBtn)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        closeBtn.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.width.height.equalTo(44)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        nftsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.height.equalTo(22)
            make.leading.equalTo(20)
        }
        nftsTxtFiled.snp.makeConstraints { make in
            make.top.equalTo(nftsLabel.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
//        tokenLabel.snp.makeConstraints { make in
//            make.top.equalTo(nftsTxtFiled.snp.bottom).offset(20)
//            make.leading.equalTo(20)
//            make.height.equalTo(22)
//        }
//        tokenTxtFiled.snp.makeConstraints { make in
//            make.top.equalTo(tokenLabel.snp.bottom).offset(8)
//            make.leading.equalTo(20)
//            make.trailing.equalTo(-20)
//            make.height.equalTo(46)
//        }
        importBtn.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
             } else {
                 make.bottom.equalTo(0)
            }
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
        }
    }
    
    @objc private func closeBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        
    }
    
    @objc private func importBtnClick() {
        addNFT()
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
        label.text = "Import NFTs"
        label.font = UIFont.init(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var nftsLabel: UILabel = {
        let label = UILabel()
        label.text = "NFT Contract Address"
        label.font = UIFont.init(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var nftsTxtFiled: UITextField = {
        let textfield = UITextField()
        let textplace = "0x"
        let placeholder = NSMutableAttributedString()
        placeholder.add(text: textplace) { (attributes) in
            attributes.customFont(12.0, NotoSans)
        }
        textfield.attributedPlaceholder = placeholder
        textfield.font = UIFont(name: NotoSans, size: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//        textfield.becomeFirstResponder()
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
        textfield.clearButtonMode = .always
        textfield.layer.cornerRadius = 8
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return textfield
    }()
    
    private lazy var tokenLabel: UILabel = {
        let label = UILabel()
        label.text = "Token ID"
        label.font = UIFont.init(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var tokenTxtFiled: UITextField = {
        let textfield = UITextField()
        let textplace = "Token ID"
        let placeholder = NSMutableAttributedString()
        placeholder.add(text: textplace) { (attributes) in
            attributes.customFont(12.0, NotoSans)
        }
        textfield.attributedPlaceholder = placeholder
        textfield.font = UIFont(name: NotoSans, size: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//        textfield.becomeFirstResponder()
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
        textfield.clearButtonMode = .always
        textfield.layer.cornerRadius = 8
        textfield.layer.masksToBounds = true
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        return textfield
    }()
    
    private lazy var importBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#35C1D8")
        btn.setTitle("Import", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(importBtnClick), for: .touchUpInside)
        return btn
    }()
    

}

extension Go23AddNFTView {
    
    private func addNFT() {
        guard let shared = Go23WalletSDK.shared
        else {
            return
        }
        
        guard let addr = self.nftsTxtFiled.text, addr.count > 0 else {
            return
        }
//        self.hud = MBProgressHUD.showAdded(to: self, animated: true)
        Go23Loading.loading()
        shared.addNFT(with: addr, walletAddress: Go23WalletMangager.shared.address, chainId: Go23WalletMangager.shared.walletModel?.chainId ?? 0) {  [weak self]status in
//            self?.hud?.hide(animated: true)
            Go23Loading.clear()
            if status {
//                let hud = MBProgressHUD.showAdded(to: self ?? UIView(), animated: true)
//                hud.mode = .text
//                hud.label.text = "add NFT Success!"
//                hud.label.font = UIFont(name: NotoSans, size: 16)
//                hud.hide(animated: true, afterDelay: 1)
                let totast = Go23Toast.init(frame: .zero)
                totast.show("add NFT Success!", after: 1)
//                self?.closeBtnClick()
                return
            } else {
//                let hud = MBProgressHUD.showAdded(to: self ?? UIView(), animated: true)
//                hud.mode = .text
//                hud.label.text = "add NFT failed!"
//                hud.label.font = UIFont(name: NotoSans, size: 16)
//                hud.hide(animated: true, afterDelay: 1)
//                let totast = Go23Toast.init(frame: .zero)
                let totast = Go23Toast.init(frame: .zero)
                totast.show("add NFT failed!", after: 1)
                return
            }
        }


    }
    

}
