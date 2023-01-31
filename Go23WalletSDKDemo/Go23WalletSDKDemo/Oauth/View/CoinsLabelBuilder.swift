//
//  CoinsLabelBuilder.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/31.
//

import UIKit

public class CoinsLabel: UILabel {}

public class CoinsLabelBuilder {
    private var textColor: UIColor!
    private var textAlignment: NSTextAlignment = .left
    private var font: UIFont!
    private var numberOfLines: Int = 0
    private var text: String?
    private var attributedText: NSAttributedString?
    private var lineBreakMode: NSLineBreakMode = .byWordWrapping
    private var adjustsFontSizeToFitWidth: Bool = false
    private var isSkeletonable: Bool = false

    private init() {
        font = UIFont.systemFont(ofSize: 12)
        textColor = UIColor.rdt_HexOfColor(hexString: "27303D")
        textAlignment = .left
    }
    
    @discardableResult
    public func withLineBreakMode(_ value: NSLineBreakMode) -> CoinsLabelBuilder {
        lineBreakMode = value
        return self
    }
    
    @discardableResult
    public func withTextColor(_ value: UIColor!) -> CoinsLabelBuilder {
        textColor = value
        return self
    }
    
    @discardableResult
    public func withAdjustsFontSizeToFitWidth(_ value: Bool) -> CoinsLabelBuilder {
        adjustsFontSizeToFitWidth = value
        return self
    }
    
    @discardableResult
    public func withTextAlignment(_ value: NSTextAlignment) -> CoinsLabelBuilder {
        textAlignment = value
        return self
    }
    
    @discardableResult
    public func withFont(_ value: UIFont!) -> CoinsLabelBuilder {
        font = value
        return self
    }
    
    @discardableResult
    public func withNumberOfLines(_ value: Int) -> CoinsLabelBuilder {
        numberOfLines = value
        return self
    }
    
    @discardableResult
    public func withText(_ value: String?) -> CoinsLabelBuilder {
        text = value
        return self
    }
    
    @discardableResult
    public func withAttributedText(_ value: NSAttributedString?) -> CoinsLabelBuilder {
        attributedText = value
        return self
    }
    
    @discardableResult
    public func withIsSkeletonable(_ value: Bool) -> CoinsLabelBuilder {
        isSkeletonable = value
        return self
    }
    
    public func build() -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = font
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        if let attributedText = attributedText {
            label.attributedText = attributedText
        } else {
            label.text = text
        }
        return label
    }
    
    public static func defaultBuilder(text: String? = nil, font: UIFont? = UIFont.systemFont(ofSize: 12)) -> CoinsLabelBuilder {
        return CoinsLabelBuilder().withText(text).withFont(font)
    }
}


