//
//  Go23SettingEmailView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/4.
//
import UIKit
import MBProgressHUD
import Go23SDK

class Go23SettingEmailView: UIView, Go23NetStatusProtocol {
    
    var confirmBlock:(()->())?
    var closeBlock: (()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        changeSendBtnStatus(status: false)
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        roundCorners([.topLeft,.topRight], radius: 12)

        backgroundColor = .white
        addSubview(titleLabel)
//        addSubview(closeBtn)
        addSubview(emailLabel)
        addSubview(emailTxtFiled)
//        addSubview(codeLabel)
//        addSubview(codeTxtFiled)
//        addSubview(sendBtn)
        addSubview(confirmBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
//        closeBtn.snp.makeConstraints { make in
//            make.trailing.equalTo(0)
//            make.width.height.equalTo(44)
//            make.centerY.equalTo(titleLabel.snp.centerY)
//        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(20)
            make.height.equalTo(22)
        }
        emailTxtFiled.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }

//        codeLabel.snp.makeConstraints { make in
//            make.top.equalTo(emailTxtFiled.snp.bottom).offset(12)
//            make.leading.equalTo(20)
//            make.height.equalTo(22)
//        }
//        codeTxtFiled.snp.makeConstraints { make in
//            make.top.equalTo(codeLabel.snp.bottom).offset(8)
//            make.leading.equalTo(20)
//            make.trailing.equalTo(-20)
//            make.height.equalTo(46)
//        }
//        sendBtn.snp.makeConstraints { make in
//            make.height.equalTo(44)
//            make.width.equalTo(60)
//            make.trailing.equalTo(-20)
//            make.centerY.equalTo(codeTxtFiled.snp.centerY)
//        }
        confirmBtn.snp.makeConstraints { make in
//            if #available(iOS 11.0, *) {
//                 make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
//             } else {
//                 make.bottom.equalTo(0)
//            }
            make.top.equalTo(emailTxtFiled.snp.bottom).offset(50)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        

    }
    
    
    @objc private func confirmBtnClick() {
        if !isReachable() {
            let toast = Go23Toast.init(frame: .zero)
            toast.show("Network is lost, check and try again!", after: 1)
            return
        }
        
        if let emailT = emailTxtFiled.text, !validateEmail(email: emailT) {
//            let hud = MBProgressHUD.showAdded(to: self, animated: true)
//            hud.mode = .text
//            hud.label.text = "Email input error!"
//            hud.label.font = UIFont(name: NotoSans, size: 16)
//            hud.hide(animated: true, afterDelay: 1)
            let totast = Go23Toast.init(frame: .zero)
            totast.show("Email input error!", after: 1)
            return
        }
        
        if let emailT = emailTxtFiled.text, emailT.count > 0 {
            UserDefaults.standard.set(emailT, forKey: kEmailPrivateKey)
            Go23WalletSDK.auth(appKey: "OcHB6Ix8bIWiOyE35ze6Ra9e", secretKey: "KX6OquHkkKQmzLSncmnmNt2q") {[weak self] result in
                if result {
                    self?.confirmBlock?()
                } else {
                    let toast = Go23Toast.init(frame: .zero)
                    toast.show("Go23WalletSDK auth failed!", after: 1)
                }
                print("Go23WalletSDK.auth === \(result)")
            }
            self.confirmBlock?()
            return
        }
//        let hud = MBProgressHUD.showAdded(to: self, animated: true)
//        hud.mode = .text
//        hud.label.text = "Please enter email!"
//        hud.label.font = UIFont(name: NotoSans, size: 16)
//        hud.hide(animated: true, afterDelay: 1)
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Please enter email!", after: 1)
    }
    
    
    func validateEmail(email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
    @objc private func closeBtnClick() {
        self.closeBlock?()
        
    }
    
    @objc private func sendClick() {
        sendBtn.isUserInteractionEnabled = false
        sendBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "BFBFBF"), for: .normal)
    }
    
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        let imgv = UIImageView()
        imgv.image = UIImage.init(named: "close")
        btn.addSubview(imgv)
        imgv.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(12)
        }
        btn.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.text = "Set Pincode"
//        label.font = UIFont.init(name: BarlowCondensed, size: 24)
//        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Login")

        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
//        label.font = UIFont(name: NotoSans, size: 14)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var emailTxtFiled: UITextField = {
        let textfield = UITextField()
//        let textplace = "Enter PIN Code"
//        let placeholder = NSMutableAttributedString()
//        placeholder.add(text: textplace) { (attributes) in
//            attributes.customFont(12.0, NotoSans)
//        }
//        textfield.attributedPlaceholder = placeholder
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
//        textfield.font = UIFont(name: NotoSans, size: 14)
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//        textfield.becomeFirstResponder()
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
        textfield.clearButtonMode = .always
        textfield.layer.cornerRadius = 8
//        textfield.isSecureTextEntry = true
//        textfield.layer.masksToBounds = true
//        textfield.layer.borderWidth = 1
//        textfield.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        textfield.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        textfield.addTarget(self, action: #selector(textDidChange(_ :)), for: .editingChanged)
        return textfield
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Verification code"
//        label.font = UIFont(name: NotoSans, size: 14)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var codeTxtFiled: UITextField = {
        let textfield = UITextField()
//        let textplace = "Enter PIN Code"
//        let placeholder = NSMutableAttributedString()
//        placeholder.add(text: textplace) { (attributes) in
//            attributes.customFont(12.0, NotoSans)
//        }
//        textfield.attributedPlaceholder = placeholder
//        textfield.font = UIFont(name: NotoSans, size: 14)
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
//        textfield.becomeFirstResponder()
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
//        textfield.clearButtonMode = .always
        textfield.layer.cornerRadius = 8
        textfield.isSecureTextEntry = true
//        textfield.layer.masksToBounds = true
//        textfield.layer.borderWidth = 1
//        textfield.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        textfield.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return textfield
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
//        btn.setTitle("Confirm", for: .normal)
//        btn.setTitleColor(.white, for: .normal)
//        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        btn.setAttributedTitle(String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 24), wordspace: 0.5, color: UIColor.white,alignment: .center, title: "Confirm"), for: .normal)
        return btn
    }()
    
    private lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
//        btn.titleLabel?.font = UIFont(name: NotoSans, size: 14)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return btn
    }()
    
    
}

extension Go23SettingEmailView {
    @objc func textDidChange(_ textField:UITextField) {
        print("event:\(textField.text)")
        if let txt = textField.text {
            if txt.count > 0 {
                changeSendBtnStatus(status: true)
            } else {
                changeSendBtnStatus(status: false)
            }
        }
        
    }
    private func changeSendBtnStatus(status: Bool) {
        if status {
            self.confirmBtn.isUserInteractionEnabled = true
            self.confirmBtn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        } else {
            self.confirmBtn.isUserInteractionEnabled = false
            self.confirmBtn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#E1F4F5")
        }
    }
}
