//
//  Go23AddView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/5.
//

import UIKit
import SnapKit
import Go23WalletSDK

class Go23AddView: UIView {
    
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
        addSubview(tokenView)
        addSubview(nftView)
        
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
        tokenView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(60)
        }
        nftView.snp.makeConstraints { make in
            make.top.equalTo(tokenView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(60)
        }
    }
    
    
    
    @objc private func closeBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        
    }
    
    @objc private func tokenClick() {
        
        closeBtnClick()
        
        let vc = Go23AddTokenViewController()
        currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func nftClick() {
        closeBtnClick()
        let alert = Go23AddNFTView(frame: CGRectMake(0, 0, ScreenWidth, 365))
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true
        ovc.shouldKeyboardChangeFollow = true
        ovc.keyboardRelativeOffset = -200

        UIApplication.shared.keyWindow?.present(overlay: ovc)
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
//        label.text = "Import assets"
//        label.font = UIFont.init(name: BarlowCondensed, size: 20)
//        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Import assets")
        return label
    }()
    
    private lazy var tokenView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#E1F4F5")
        view.layer.cornerRadius = 8.0
        let control = UIControl()
        view.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        control.addTarget(self, action: #selector(tokenClick), for: .touchUpInside)
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "Tokens"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(18)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "rightArrow")
        view.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.height.equalTo(13)
            make.width.equalTo(13)
            make.centerY.equalToSuperview()
        }
        return view
    }()
    
    private lazy var nftView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#E2E1F5")
        view.layer.cornerRadius = 8.0
        let control = UIControl()
        view.addSubview(control)
        control.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        control.addTarget(self, action: #selector(nftClick), for: .touchUpInside)
        let label = UILabel()
        label.font = UIFont(name: NotoSans, size: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.text = "NFTs"
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(18)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "rightArrow")
        view.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.trailing.equalTo(-18)
            make.height.equalTo(13)
            make.width.equalTo(13)
            make.centerY.equalToSuperview()
        }
        return view
    }()
}
