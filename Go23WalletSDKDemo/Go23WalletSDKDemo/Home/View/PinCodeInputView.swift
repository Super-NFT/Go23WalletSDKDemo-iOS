//
//  PinCodeInputView.swift
//  Go23Wallet
//
//  Created by luming on 2022/12/4.
//

import UIKit
import SwiftUI

class PincodeTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

class PincodeLabel: UILabel {
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
        textAlignment = .center
        layer.cornerRadius = 6.0
        layer.borderWidth = 1
        layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        layer.masksToBounds = true
        font = .systemFont(ofSize: 19.0)
        textColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct PincodConfig {
    var eachHeight = 0.0
    var eachWidth = 0.0
    var margin = 0.0
}

class PinCodeInputView: UIView {
    
    var pincodeViews = [PincodeLabel]()
    var pincodeCount = 6 // default is 6 pincode
    var pincodeConfig = PincodConfig()
    
    var inputCompleteBlock: ((String) -> Void)?
    
    // Pincode count
    init(frame: CGRect, with count: Int, config: PincodConfig) {
        super.init(frame: frame)
        backgroundColor = .white
        pincodeCount = count
        pincodeConfig = config
        
        initCustomViews()
    }
    
    func initCustomViews() {
        addSubview(textField)
        textField.frame = self.bounds
        addSubview(coverView)
        coverView.frame = self.bounds
        
        for index in 0 ..< pincodeCount {
            let label = PincodeLabel()
            label.frame = CGRect(x: (pincodeConfig.eachWidth + pincodeConfig.margin) * Double(index), y: 0.0, width: pincodeConfig.eachWidth, height: pincodeConfig.eachHeight)
            addSubview(label)
            pincodeViews.append(label)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // clear input code
    func clear() {
        for label in pincodeViews {
            label.text = ""
            label.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
        }
        textField.text = ""
    }
    
    private lazy var textField: PincodeTextField = {
        let inputField = PincodeTextField()
        inputField.delegate = self
        inputField.keyboardType = .numberPad
        inputField.textColor = UIColor.rdt_HexOfColor(hexString: "#000000")
        inputField.tintColor = .clear
        return inputField
    }()
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        
        return view
    }()
}

extension PinCodeInputView: UITextFieldDelegate {
    
    func startInput() {
        textField.becomeFirstResponder()
    }
    
    private func inputPincodeEnd() {
        textField.endEditing(false)
        textField.resignFirstResponder()
        userInput()
    }
    
    private func userInput() {
        if inputCompleteBlock != nil, let text = textField.text {
            inputCompleteBlock!(text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let location = range.location
        if location >= pincodeCount {
            return false
        }
        
        if location < pincodeViews.count {
            let label = pincodeViews[location]
            
            if string.count > 0 {
//                label.text = "●"
                label.text = string
                label.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.black.cgColor
            } else {
                label.text = ""
                label.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#F5F5F5")
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.rdt_HexOfColor(hexString: "#D9D9D9").cgColor
            }
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let count = textField.text?.count, count == pincodeCount {
            inputPincodeEnd()
        } else {
            userInput()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newPosition = textField.endOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
    }
}
