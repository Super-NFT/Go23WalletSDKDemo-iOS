//
//  Go23SettingAccountView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/4.
//
import UIKit

class Go23SettingAccountView: UIView {
    
    var confirmBlock:(()->())?
    var closeBlock: (()->())?
    var areaCode = "+63"
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
        addSubview(emailBtn)
        addSubview(smsBtn)
        addSubview(emailTxtFiled)
        addSubview(smsCodeBtn)
        addSubview(smsTxtFiled)
        addSubview(confirmBtn)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        emailBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(20)
            make.width.equalTo(50)
            make.height.equalTo(22)
        }
        
        smsBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.equalTo(emailBtn.snp.right)
            make.width.equalTo(50)
            make.height.equalTo(22)
        }
        emailTxtFiled.snp.makeConstraints { make in
            make.top.equalTo(emailBtn.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        smsCodeBtn.snp.makeConstraints { make in
            make.top.equalTo(emailBtn.snp.bottom).offset(8)
            make.leading.equalTo(20)
            make.width.equalTo(85)
            make.height.equalTo(46)
        }
        smsTxtFiled.snp.makeConstraints { make in
            make.top.equalTo(emailBtn.snp.bottom).offset(8)
            make.left.equalTo(smsCodeBtn.snp.right).offset(15)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(emailTxtFiled.snp.bottom).offset(50)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(46)
        }
        

    }
    
    
    @objc private func confirmBtnClick() {
        
        if let emailT = emailTxtFiled.text, emailT.count > 0 {
            
            if  !validateEmail(email: emailT) {
                let totast = Go23Toast.init(frame: .zero)
                totast.show("Email input error!", after: 1)
                return
            }
            
            UserDefaults.standard.set(emailT, forKey: kEmailPrivateKey)
            self.confirmBlock?()
            return
        }
        
        if let smsT = smsTxtFiled.text, smsT.count > 0 {
            
            UserDefaults.standard.set(self.areaCode+" "+smsT, forKey: kPhonePrivateKey)
            self.confirmBlock?()
            return
        }
        
        let totast = Go23Toast.init(frame: .zero)
        totast.show("Please enter email or SMS", after: 1)
    }
    
    
    func validateEmail(email: String) -> Bool {
        if email.count == 0 {
            return false
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    
    @objc private func emailBtnClick() {
        emailBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        smsBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        emailTxtFiled.isHidden = false
        smsCodeBtn.isHidden = true
        smsTxtFiled.isHidden = true
        
    }
    
    @objc private func smsBtnClick() {
        emailBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        smsBtn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        emailTxtFiled.isHidden = true
        smsCodeBtn.isHidden = false
        smsTxtFiled.isHidden = false
    }
    
    @objc private func smsCodeBtnClick() {
        codeTxtFiled.resignFirstResponder()
        let alert = Go23PhoneSelectedView(frame: CGRectMake(0, 0, ScreenWidth, 720))
        
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = false
        
        alert.chooseBlock = {[weak self]model in
            self?.areaCode = model
            let attri = NSMutableAttributedString()
            attri.add(text: model) { attr in
                attr.font(14)
                attr.color(UIColor.rdt_HexOfColor(hexString: "#262626"))
                attr.kern(0.5)
            }
            attri.add(text: " ") { attr in
                
            }
            attri.addImage("arrowDown", CGRectMake(0, 0, 12, 12))
            self?.smsCodeBtn.setAttributedTitle(attri, for: .normal)
            
        }
        UIApplication.shared.keyWindow?.present(overlay: ovc)
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
        label.attributedText = String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 20), wordspace: 0.5, color: UIColor.rdt_HexOfColor(hexString: "#262626"),alignment: .center, title: "Login")

        return label
    }()
    
    private lazy var emailBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Email", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        btn.addTarget(self, action: #selector(emailBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var smsBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("SMS", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#8C8C8C"), for: .normal)
        btn.addTarget(self, action: #selector(smsBtnClick), for: .touchUpInside)
        return btn
    }()
    
    private lazy var emailTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
        textfield.clearButtonMode = .always
        textfield.layer.cornerRadius = 8
        textfield.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        textfield.addTarget(self, action: #selector(textDidChange(_ :)), for: .editingChanged)
        return textfield
    }()
    
    private lazy var smsCodeBtn: UIButton = {
        let btn = UIButton(type: .custom)
//        btn.setTitle("SMS", for: .normal)
        let attri = NSMutableAttributedString()
        attri.add(text: "+63") { attr in
            attr.font(14)
            attr.color(UIColor.rdt_HexOfColor(hexString: "#262626"))
            attr.kern(0.5)
        }
        attri.add(text: " ") { attr in
            
        }
        attri.addImage("arrowDown", CGRectMake(0, 0, 12, 12))
        btn.setAttributedTitle(attri, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 8
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#262626"), for: .normal)
        btn.addTarget(self, action: #selector(smsCodeBtnClick), for: .touchUpInside)
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F9F9F9")
        btn.isHidden = true
        return btn
    }()
    
    private lazy var smsTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = .no
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
        textfield.clearButtonMode = .always
        textfield.layer.cornerRadius = 8
        textfield.placeholder = "Phone no."
        textfield.keyboardType = .phonePad
        textfield.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        textfield.addTarget(self, action: #selector(textDidChange(_ :)), for: .editingChanged)
        textfield.isHidden = true
        return textfield
    }()
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Verification code"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        return label
    }()
    
    private lazy var codeTxtFiled: UITextField = {
        let textfield = UITextField()
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.tintColor = UIColor.rdt_HexOfColor(hexString: "#262626")
        textfield.leftViewMode = .always
        textfield.leftView = UIView.init(frame: CGRectMake(0, 0, 15, 0))
        textfield.layer.cornerRadius = 8
        textfield.isSecureTextEntry = true
        textfield.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        return textfield
    }()
    
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        btn.setAttributedTitle(String.getAttributeString(font: UIFont(name: BarlowCondensed, size: 24), wordspace: 0.5, color: UIColor.white,alignment: .center, title: "Confirm"), for: .normal)
        return btn
    }()
    
    private lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Send", for: .normal)
        btn.setTitleColor(UIColor.rdt_HexOfColor(hexString: "#00D6E1"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(sendClick), for: .touchUpInside)
        return btn
    }()
    
    
}

extension Go23SettingAccountView {
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
