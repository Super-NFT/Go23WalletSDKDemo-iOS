//
//  Go23ForgetPwdView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit
import Go23SDK

class Go23ForgetPwdView: UIView {

    var settingType: SettingType = .resharding
    var pk = ""
    var pinCode = ""
    
    private var resendTimer: Timer?
    private var timeInterval: Int = 60

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        
        getKeygen()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeTimer()
    }
    
    private func initSubviews() {
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(emailLabel)
        addSubview(codeView)
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
            make.centerX.equalToSuperview().offset(-30)
        }
        
        notReceiveBtn.snp.makeConstraints { make in
            make.top.equalTo(emailTipsLabel.snp.bottom).offset(3)
            make.height.equalTo(16)
            make.centerX.equalToSuperview().offset(45)
        }
        
        if Go23WalletMangager.shared.email.count > 0 {
            emailLabel.text = Go23WalletMangager.shared.email
        } else {
            emailLabel.text = Go23WalletMangager.shared.phone
        }


    }
    
    func filled(email: String){
        if Go23WalletMangager.shared.email.count > 0 {
            emailLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: Go23WalletMangager.shared.email)
            emailTipsLabel.text = "Enter the 6-digit code sent to your email."
        } else {
            emailLabel.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: Go23WalletMangager.shared.phone)
            emailTipsLabel.text = "Enter the 6-digit code sent to your SMS."
            
        }
    }
    
    
    private func getKeygen() {
        Go23Net.getServerShard(with: Go23WalletMangager.shared.address) { [weak self] str in
            if let obj = str {
                self?.pk = obj
            }
            
        }
    }
    
    @objc private func verifyBtnClick() {
        
        guard let shared = Go23WalletSDK.shared else {
            return
        }
        
        if Go23WalletMangager.shared.email.count > 0, pinCode.count != 6 {
            return
        }
        
        if Go23WalletMangager.shared.phone.count > 0, pinCode.count != 4 {
            return
        }
        
        var codeType: Go23VerifyCode = .email(pinCode)
        if Go23WalletMangager.shared.phone.count > 0 {
            codeType = .phone(pinCode)
        }
        if settingType == .resharding {
            

            shared.forgetShardPincode(with: Go23WalletMangager.shared.address, shard: self.pk, verifyCode: codeType, delegate: self) { [weak self] status in

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
                    case .failure(let result):
                        switch result {
                        case .networkError(let msg):
                            let totast = Go23Toast.init(frame: .zero)
                            totast.show(msg, after: 1)
                            self?.codeView.clear()
                        default:
                            let totast = Go23Toast.init(frame: .zero)
                            totast.show("Resharding failed, please try again!", after: 1)
                        }
                    
                        
                    }
                    
            }

        } else {
            
            shared.restoreWallet(with: Go23WalletMangager.shared.address, verifyCode: codeType, delegate: self) { [weak self]status in
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
                            let totast = Go23Toast.init(frame: .zero)
                            totast.show("Pincode error, please try again!", after: 1)
                        case .networkError(let msg):
                            let totast = Go23Toast.init(frame: .zero)
                            totast.show(msg, after: 1)
                            self?.codeView.clear()
                        default:
                            break
                            
                        }
                    }
                    
                
            }
        }
        
    }

    
    @objc private func notReceiveClick() {
        
        guard let shared = Go23WalletSDK.shared else {
            return
        }

        creatTimer()

        var str = ""
        if settingType == .recover {
            str = "recover"
        } else {
            str = "reshare"
        }

        if Go23WalletMangager.shared.email.count > 0 {
            shared.sendVerifyCode(for: .email(str)) { status in
            }
        } else {
            shared.sendVerifyCode(for: .phone(str)) { status in
            }
        }
        
    }
    
    private func creatTimer() {
        notReceiveBtn.setTitle("Wait 60s", for: .normal)
        resendTimer = Timer(timeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.timeInterval -= 1
            self?.notReceiveBtn.isEnabled = false
            self?.notReceiveBtn.setTitle("Wait \(self?.timeInterval ?? 0)s", for: .normal)
            self?.notReceiveBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
            if self?.timeInterval == 0 {
                self?.removeTimer()
                self?.timeInterval = 60
                self?.notReceiveBtn.isEnabled = true
                self?.notReceiveBtn.setTitle("Resend.", for: .normal)
                self?.notReceiveBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
            }
        }
        guard let timer = resendTimer else {
            return
        }
        RunLoop.current.add(timer, forMode: .common)
        
    }
    
    private func removeTimer() {
        self.resendTimer?.invalidate()
        self.resendTimer = nil
    }
    
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = String.getAttributeString(font: UIFont.systemFont(ofSize: 14), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#8C8C8C"),alignment: .center, title: "Verify your account")
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
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Verify", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(verifyBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var emailTipsLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter the 6-digit code sent to your email."
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        label.textAlignment = .center
        return label
    }()
    
    lazy var notReceiveLabel: UILabel = {
        let label = UILabel()
        label.text = "Didn't receive it?"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#8C8C8C")
        return label
    }()
    
    lazy var notReceiveBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Resend.", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(notReceiveClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var codeView: PinCodeInputView = {
        let eachWidth = 44.0
        let config = PincodConfig(eachHeight: 48.0, eachWidth: eachWidth, margin: 12.0)
        if Go23WalletMangager.shared.email.count > 0 {
            let view = PinCodeInputView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 44*6 - 12*5)/2.0, y: 100.0, width: UIScreen.main.bounds.size.width, height: 60.0), with: 6, config: config)
            view.inputCompleteBlock = { [weak self] (pincode) in
                self?.pinCode = pincode
                if pincode.count == 6, Go23WalletMangager.shared.email.count > 0 {
                    self?.verifyBtnClick()
                }
            }
            return view
        }
        let view = PinCodeInputView(frame: CGRect(x: (UIScreen.main.bounds.size.width - 44*4 - 12*3)/2.0, y: 100.0, width: UIScreen.main.bounds.size.width, height: 60.0), with: 4, config: config)
        view.pincodeCount = 4
        view.inputCompleteBlock = { [weak self] (pincode) in
            self?.pinCode = pincode
            if pincode.count == 4, Go23WalletMangager.shared.phone.count > 0 {
                self?.verifyBtnClick()
            }
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
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        Go23Loading.loading()
    }
    
    func setPincodePageWillDismiss() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        print("=========setPincodePageWillDismiss")
        Go23Loading.clear()
    }
}
