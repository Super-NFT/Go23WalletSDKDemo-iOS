//
//  Go23ForgetPwdView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import MBProgressHUD
import Go23WalletSDK

class Go23ForgetPwdView: UIView {

    var settingType: SettingType = .resharding
    
    var pk = ""
    
    var pinCode = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        
        getKeygen()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(emailLabel)
        addSubview(codeView)
//        addSubview(sendBtn)
        addSubview(emailVerifyBtn)
        addSubview(emailTipsLabel)
        addSubview(notReceiveLabel)
        addSubview(notReceiveBtn)
        
        
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(24)
            make.centerX.equalToSuperview()
        }
        
        emailVerifyBtn.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(124)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(52)
        }
        
        emailTipsLabel.snp.makeConstraints { make in
            make.top.equalTo(emailVerifyBtn.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(16)
        }
        notReceiveLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTipsLabel.snp.bottom).offset(3)
            make.height.equalTo(16)
            make.centerX.equalToSuperview().offset(-45)
        }
        
//        let attri = NSMutableAttributedString()
//        attri.add(text: "Didn‘t receive?") { attr in
//            attr.customFont(12, NotoSans)
//            attr.color(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"))
//        }.add(text: "Please click resend") { attr in
//            attr.customFont(12, NotoSans)
//            attr.color(UIColor.rdt_HexOfColor(hexString: "#35C1D8"))
//        }
//        notReceiveLabel.attributedText = attri
        
        notReceiveBtn.snp.makeConstraints { make in
            make.top.equalTo(emailTipsLabel.snp.bottom).offset(3)
            make.height.equalTo(16)
            make.centerX.equalToSuperview().offset(65)
        }
        
        emailLabel.text = Go23WalletMangager.shared.email


    }
    
    func filled(email: String){
//        emailLabel.text = Go23WalletMangager.shared.email
        emailLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: Go23WalletMangager.shared.email)
    }
    
    
    private func getKeygen() {
        Go23Net.getServerShard(with: Go23WalletMangager.shared.address) { [weak self] str in
            if let obj = str {
                self?.pk = obj
            }
            
        }
    }
    
    @objc private func verifyBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        
        guard let shared = Go23WalletSDK.shared, pinCode.count == 6 else {
            return
        }
        if settingType == .resharding {
            
            shared.forgetShardPincode(with: Go23WalletMangager.shared.address, shard: self.pk, verifyCode: self.pinCode, delegate: self) { [weak self] status in
                DispatchQueue.main.async {
                    switch status {
                    case .success(let str):
                        UserDefaults.standard.set(str, forKey: kPrivateKeygenKey)
                        ///v1/merchant/update_keygen
                        if  let keygen = UserDefaults.standard.value(forKey: kPrivateKeygenKey) as? String, keygen.count > 0 {
                            Go23Net.updateServerShard(with: keygen, address: Go23WalletMangager.shared.address) { status in
                                if status {
                                    UserDefaults.standard.set("", forKey: kPrivateKeygenKey)
                                }
                            }
                        }
                        let alert = Go23PwdSuccessView(frame: CGRectMake(0, 0, ScreenWidth, 720))
                        let ovc = OverlayController(view: alert)
                        ovc.maskStyle = .black(opacity: 0.4)
                        ovc.layoutPosition = .bottom
                        ovc.presentationStyle = .fromToBottom
                        ovc.isDismissOnMaskTouched = false
                        ovc.isPanGestureEnabled = true
                        UIApplication.shared.keyWindow?.present(overlay: ovc)
                    case .failure:
//                        let hud = MBProgressHUD.showAdded(to: currentViewController()?.view ?? UIView(), animated: true)
//                        hud.mode = .text
//                        hud.label.font = UIFont(name: NotoSans, size: 16)
//                        hud.label.text = "Resharding failed, please try again!"
//                        hud.hide(animated: true, afterDelay: 1)
                        
                        let totast = Go23Toast.init(frame: .zero)
                        totast.show("Resharding failed, please try again!", after: 1)
                        
                    }
                    
                }
            }

        } else {
//            let hud = MBProgressHUD.showAdded(to: currentViewController()?.view ?? UIView(), animated: true)
//            Go23Loading.loading()
            shared.restoreWallet(with: Go23WalletMangager.shared.address, verifyCode: self.pinCode, delegate: self) { [weak self]status in
//                DispatchQueue.main.async {
//                    hud.hide(animated: true)
//                Go23Loading.clear()
                    switch status {
                    case .success:
                        let alert = Go23PwdSuccessView(frame: CGRectMake(0, 0, ScreenWidth, 720))
                        let ovc = OverlayController(view: alert)
                        ovc.maskStyle = .black(opacity: 0.4)
                        ovc.layoutPosition = .bottom
                        ovc.presentationStyle = .fromToBottom
                        ovc.isDismissOnMaskTouched = false
                        ovc.isPanGestureEnabled = true
                        UIApplication.shared.keyWindow?.present(overlay: ovc)
                    case .failure(let result):
                        switch result {
                        case .forgetPincode:
                            let alert = Go23ReshardingView(frame: CGRectMake(0, 0, ScreenWidth, 720),type: .resharding)
                            let ovc = OverlayController(view: alert)
                            ovc.maskStyle = .black(opacity: 0.4)
                            ovc.layoutPosition = .bottom
                            ovc.presentationStyle = .fromToBottom
                            ovc.isDismissOnMaskTouched = false
                            ovc.isPanGestureEnabled = true
                            
                            UIApplication.shared.keyWindow?.present(overlay: ovc)
                        case .errorPincode:
//                            let hud = MBProgressHUD.showAdded(to: currentViewController()?.view ?? UIView(), animated: true)
//                            hud.mode = .text
//                            hud.label.text = "Pincode error, please try again!"
//                            hud.label.font = UIFont(name: NotoSans, size: 16)
//                            hud.hide(animated: true, afterDelay: 1)
                            
                            let totast = Go23Toast.init(frame: .zero)
                            totast.show("Pincode error, please try again!", after: 1)
                        default:
                            break
                            
                        }
                    }
                    
//                }
                
            }
        }
        
    }

    
    @objc private func notReceiveClick() {
        
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        var str = ""
        if settingType == .recover {
            str = "recover"
        } else {
            str = "reshare"
        }
        
        shared.sendVerifyCode(for: .email(str)) { status in
            
        }
        
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont(name: NotoSans, size: 14)
//        label.textColor = UIColor.init(named: "#8C8C8C")
//        label.textAlignment = .center
//        label.text = "Verify"
        label.attributedText = String.getAttributeString(font: UIFont(name: NotoSans, size: 14), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#8C8C8C"),alignment: .center, title: "Verify your account")
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: BarlowCondensed, size: 20)
        label.textColor = UIColor.init(named: "#262626")
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailVerifyBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#35C1D8")
        btn.setTitle("Verify", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(verifyBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailTipsLabel: UILabel = {
        let label = UILabel()
        label.text = "An email with code has been sent to your email."
        label.font = UIFont(name: NotoSans, size: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        return label
    }()
    
    lazy var notReceiveLabel: UILabel = {
        let label = UILabel()
        label.text = "Didn't receive it?"
        label.font = UIFont(name: NotoSans, size: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    lazy var notReceiveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Please click resend.", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#35C1D8"), for: .normal)
        btn.titleLabel?.font = UIFont(name: NotoSans, size: 12)
        btn.addTarget(self, action: #selector(notReceiveClick), for: .touchUpInside)
        return btn
    }()
    
//    lazy var codeView: VerifyCodeView = {
//        let count = 6
//        let spacing: CGFloat = 18
//        let height: CGFloat = 33
//        let width: CGFloat = 33 * CGFloat(count) + spacing * CGFloat(count - 1)
//        let verifyCodeView = VerifyCodeView(frame: CGRect(x: (UIScreen.main.bounds.width - width) / 2, y: 90 , width: width, height: height))
//        verifyCodeView.verifyCount = count
//        verifyCodeView.txtBackgroundColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9")
//        verifyCodeView.cornerRadius = 2.0
//        verifyCodeView.spacing = spacing
//        verifyCodeView.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//
//
//        return verifyCodeView
//    }()
    
        lazy var codeView: PinCodeInputView = {
        let eachWidth = 44.0
        let config = PincodConfig(eachHeight: 48.0, eachWidth: eachWidth, margin: 12.0)
        let view = PinCodeInputView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 44*6 - 12*5)/2.0, y: 100.0, width: UIScreen.main.bounds.size.width, height: 60.0), with: 6, config: config)
        view.inputCompleteBlock = { [weak self] (pincode) in
            self?.pinCode = pincode
        }
        
        return view
      }()
    
}

extension Go23ForgetPwdView: Go23ReshardDelegate {
    func reshardWillStart() {
        print("=========reshardWillStart")
        Go23Loading.loading()
    }
    
    func reshardDidEnd() {
        print("=========reshardDidEnd")
        Go23Loading.clear()
    }
}

extension Go23ForgetPwdView: Go23RestoreDelegate {
    func verifyPincodePageWillShow() {
        print("=========verifyPincodePageWillShow")
        Go23Loading.loading()
    }

    func verifyPincodePageWillDismiss() {
        print("=========verifyPincodePageWillDismiss")
        Go23Loading.clear()
    }
}

extension Go23ForgetPwdView: Go23SetPincodeDelegate {
    func setPincodePageWillShow() {
        print("=========setPincodePageWillShow")
        Go23Loading.loading()
    }
    
    func setPincodePageWillDismiss() {
        print("=========setPincodePageWillDismiss")
        Go23Loading.clear()
    }
}
