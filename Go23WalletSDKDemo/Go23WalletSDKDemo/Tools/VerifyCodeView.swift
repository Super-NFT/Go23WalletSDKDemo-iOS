//
//  VerifyCodeView.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/6.
//

import UIKit

class VerifyCodeSingleView: UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//    }
}

public class VerifyCodeView: UIStackView, UITextFieldDelegate {
    
    public var borderWidth = 0.0 {
        didSet {
            for verifyCode in self.verifyCodes{
                verifyCode.layer.borderWidth = borderWidth
            }
        }
    }
    public var borderColor: UIColor = .white {
        didSet {
            for verifyCode in self.verifyCodes{
                verifyCode.layer.borderColor = borderColor.cgColor
            }
        }
    }
    public var textColor: UIColor = .black {
        didSet {
            for verifyCode in self.verifyCodes{
                verifyCode.textColor = textColor
            }
        }
    }
    public var cornerRadius = 4.0 {
        didSet {
            for verifyCode in self.verifyCodes{
                verifyCode.layer.cornerRadius = cornerRadius
                verifyCode.layer.masksToBounds = true
            }
        }
    }
    public var txtBackgroundColor: UIColor = .white {
        didSet {
            for verifyCode in self.verifyCodes{
                verifyCode.backgroundColor = txtBackgroundColor
            }
        }
    }
     var verifyCodes: [VerifyCodeSingleView]!
    
    public var font: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet{
            for verifyCode in self.verifyCodes{
                verifyCode.font = font
            }
        }
    }
    
    public var verifyCount: Int? {
        didSet{
            for _ in Range(0...(verifyCount ?? 4) - 1) {
                let singleView = VerifyCodeSingleView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
                verifyCodes.append(singleView)
                self.addArrangedSubview(singleView)
            }
        }
    }
    
    var completeHandler: ((_ verifyCode: String) -> Void)!
    
    
    lazy var hideTextField: UITextField = {
        let textfield = UITextField()
        self.addSubview(textfield)
        textfield.isHidden = true
        textfield.keyboardType = .numberPad
        textfield.delegate = self
        return textfield
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.distribution = .fillEqually
        verifyCodes = []
        verifyCount = 4
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField.text!.count <= (verifyCount ?? 4) else {
            textField.text = String(textField.text!.prefix(4))
            return
        }
        
        var index = 0
        for char in textField.text! {
            verifyCodes[index].text = String(char)
            index += 1
        }
        guard index < (verifyCount ?? 4) else {
            
            self.endEditing(true)
            self.resignFirstResponder()

//            self.completeHandler(textField.text ?? "")
            return
        }
        for i in Range(index...(verifyCount ?? 4) - 1) {
            verifyCodes[i].text = ""
        }
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        hideTextField.becomeFirstResponder()
    }
    
}

