//
//  ArcadeOAuthConfirmView.swift
//  Coins
//
//  Created by Taran on 2023/1/29.
//  Copyright © 2023 Global Commerce Technologies Pte. All rights reserved.
//

import UIKit
import KeepLayout


class ArcadeOAuthConfirmView: UIView {
    var appName: String? {
        didSet {
            guard appName != nil else {
                return
            }
            configureUI()
        }
    }
    
    var completeBlock: ((_ result: Any?) -> Void)?
    
    private lazy var titleLabel = makeLabel()
    private lazy var messageTitleLabel = makeLabel()
    private lazy var messageLabel = makeLabel()
    private lazy var confirmButton = makeConfirmButton()
    private lazy var cancelButton = makeCancelButton()
    
    init(frame: CGRect, completion: @escaping (_ result: Any?) -> Void) {
        super.init(frame: frame)
         self.completeBlock = completion
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static func show(appName: String,
                     completion: @escaping (_ result: Any?) -> Void) {
        let frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 360)
        
        let alert = ArcadeOAuthConfirmView(frame: frame, completion: completion)
        alert.appName = appName
        let ovc = OverlayController(view: alert)
        ovc.maskStyle = .black(opacity: 0.4)
        ovc.layoutPosition = .bottom
        ovc.presentationStyle = .fromToBottom
        ovc.isDismissOnMaskTouched = false
        ovc.isPanGestureEnabled = true
        UIApplication.shared.keyWindow?.present(overlay: ovc)
    }
    
    
}

private extension ArcadeOAuthConfirmView {
    func commonInit() {
        backgroundColor = .white
        layer.cornerRadius = 12
        constructUI()
        layoutUI()
        configureUI()
    }
    
    func constructUI() {
        addSubview(titleLabel)
        addSubview(messageTitleLabel)
        addSubview(messageLabel)
        addSubview(confirmButton)
        addSubview(cancelButton)
    }
    
    func layoutUI() {
        titleLabel.keepTopInset.equal = 15
        titleLabel.keepHorizontalInsets.equal = 24
        titleLabel.keepHeight.equal = 54
        
        messageTitleLabel.keepTopOffsetTo(titleLabel)?.equal = 12
        messageTitleLabel.keepHorizontalInsets.equal = 24
        messageTitleLabel.keepHeight.equal = 23
        
        messageLabel.keepTopOffsetTo(messageTitleLabel)?.equal = 12
        messageLabel.keepHorizontalInsets.equal = 24
        messageLabel.keepHeight.equal = 69
        
        confirmButton.keepTopOffsetTo(messageLabel)?.equal = 24
        confirmButton.keepHorizontalInsets.equal = 16
        confirmButton.keepHeight.equal = 54
        
        cancelButton.keepTopOffsetTo(confirmButton)?.equal = 12
        cancelButton.keepHorizontalInsets.equal = 16
        cancelButton.keepHeight.equal = 54
    }
    
    func configureUI() {
        titleLabel.attributedText = titleAttributedText()
        messageTitleLabel.attributedText = messageTitleAttributedText()
        messageLabel.attributedText = messageAttributedText()

    }
    
    @objc private func confirmBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        self.completeBlock?(true)
    }
    
    @objc private func cancelBtnClick() {
        UIApplication.shared.keyWindow?.dissmiss(overlay: .last)
        self.completeBlock?(false)
    }
}

private extension ArcadeOAuthConfirmView {
    func makeLabel() -> UILabel {
        return CoinsLabelBuilder.defaultBuilder()
            .withTextAlignment(.left)
            .build()
    }
    
    func makeConfirmButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#00D6E1")
        btn.setTitle("Continue", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(confirmBtnClick), for: .touchUpInside)
        return btn
        
    }
    
    func makeCancelButton() -> UIButton {
        let btn = UIButton(type: .custom)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor.rdt_HexOfColor(hexString: "#ffffff")
        btn.setTitle("Cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: BarlowCondensed, size: 24)
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return btn
    }
}

private extension ArcadeOAuthConfirmView {
    
    func titleAttributedText() -> NSAttributedString? {
        let text = titleText()
        return NSAttributedString(string: text, attributes: NSAttributedString.subtitle1SemiBoldAttributes())
    }
    
    func titleText() -> String {
        let format = "Authorize {.%@.} to access your Go23 account?"
        return String(format: format, appName ?? "")
    }
    
    func messageTitleAttributedText() -> NSAttributedString? {
        let text = messageTitleText()
        let attributedText = NSAttributedString(string: text, attributes: NSAttributedString.body2MediumGrayAttributes())
        return attributedText
    }
    
    func messageTitleText() -> String {
        let format = "{.%@.} is requesting access to:"
        return String(format: format, appName ?? "")
    }
    
    func messageAttributedText() -> NSAttributedString? {
        let text = messageText()
        let attributedText = NSAttributedString(string: text, attributes: NSAttributedString.body2MediumGrayAttributes())
        return attributedText
    }
    
    func messageText() -> String {
        let format = """
            · Your name
            · email and/or phone number
            · Go23 wallet public address
        """
        return format
    }
    
}



extension NSAttributedString {
    public static func subtitle1SemiBoldAttributes() -> [NSAttributedString.Key: Any] {
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = 27
        paraph.minimumLineHeight = 27
        
        return [
            .font: UIFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: UIColor.rdt_HexOfColor(hexString: "#27303D"),
            .paragraphStyle: paraph,
            .kern: CGFloat(0)
        ]
    }
    
    public static func body2MediumGrayAttributes() -> [NSAttributedString.Key: Any] {
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = 23
        paraph.minimumLineHeight = 23
        return [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor.rdt_HexOfColor(hexString: "#8793A3"),
            .paragraphStyle: paraph,
            .baselineOffset: 1,
            .kern: CGFloat(0)
        ]
    }
    
    public static func buttonSemiBoldWhiteAttributes() -> [NSAttributedString.Key: Any] {
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = 22
        paraph.minimumLineHeight = 22
        return [
            .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paraph,
            .kern: CGFloat(0)
        ]
    }
}





