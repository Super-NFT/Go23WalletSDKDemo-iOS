//
//  NSMutableAttributedString.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult
    func add(text: String, arrtibutesClosure: (inout DNArrtibutes) -> ()) -> NSMutableAttributedString {
        var arrtibutes = DNArrtibutes()
        arrtibutesClosure(&arrtibutes)
        let arrStr = NSMutableAttributedString(string: text, attributes: arrtibutes.dic)
        append(arrStr)
        return self
    }
    
    @discardableResult
    func addImage(_ name: String, _ bounds: CGRect) -> NSMutableAttributedString {
        let attch = NSTextAttachment()
        attch.image = UIImage(named: name)
        attch.bounds = bounds
        let attchAttri = NSAttributedString(attachment: attch)
        append(attchAttri)
        return self
    }
}


class DNArrtibutes {
    fileprivate var dic = [NSAttributedString.Key:Any]()
    private lazy var paragraphStyle : NSMutableParagraphStyle = {
        let ps = NSMutableParagraphStyle()
        return ps
    }()
    
    
    @discardableResult
    public func font(_ size: CGFloat) -> DNArrtibutes {
        dic[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: size)
        return self
    }
    
    @discardableResult
    public func boldFont(_ size: CGFloat) -> DNArrtibutes {
        dic[NSAttributedString.Key.font] = UIFont.boldSystemFont(ofSize: size)
        return self
    }
    
    @discardableResult
    public func customFont(_ size: CGFloat, _ name: String) -> DNArrtibutes {
        dic[NSAttributedString.Key.font] = UIFont(name: name, size: size)
        return self
    }
    
    @discardableResult
    public func weightFont(_ size: CGFloat, _ weight: UIFont.Weight) -> DNArrtibutes {
        dic[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: size, weight: weight)
        return self
    }
    
    @discardableResult
    public func color(_ color: UIColor) -> DNArrtibutes {
        dic[NSAttributedString.Key.foregroundColor] = color
        return self
    }
    
    @discardableResult
    public func oblique(_ value: Double) -> DNArrtibutes {
        dic[NSAttributedString.Key.obliqueness] = NSNumber(value: value)
        return self
    }
    
    @discardableResult
    public func expansion(_ value: Double) -> DNArrtibutes {
        dic[NSAttributedString.Key.expansion] = NSNumber(value: value)
        return self
    }
    
    @discardableResult
    public func kern(_ value: Double) -> DNArrtibutes {
        dic[NSAttributedString.Key.kern] = NSNumber(value: value)
        return self
    }
    
    @discardableResult
    public func strike(_ value: Double) -> DNArrtibutes {
        dic[NSAttributedString.Key.strikethroughStyle] = NSNumber(value: value)
        return self
    }
    
    @discardableResult
    public func strikeColor(_ color: UIColor) -> DNArrtibutes {
        dic[NSAttributedString.Key.strikethroughColor] = color
        return self
    }
    
    @discardableResult
    public func alignment(_ ali: NSTextAlignment) -> DNArrtibutes {
        paragraphStyle.alignment = ali
        dic[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return self
    }
    
    @discardableResult
    public func lineSpacing(_ ls: CGFloat) -> DNArrtibutes {
        paragraphStyle.lineSpacing = ls
        dic[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return self
    }
    
    @discardableResult
    public func lineHeightMultiple(_ ls: CGFloat) -> DNArrtibutes {
        paragraphStyle.lineHeightMultiple = ls
        dic[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        return self
    }
    
    @discardableResult
    public func paragraphStyle(_ ps: NSMutableParagraphStyle) -> DNArrtibutes {
        dic[NSAttributedString.Key.paragraphStyle] = ps
        return self
    }
    
    @discardableResult
    public func baseLineOffset(_ blo: CGFloat) -> DNArrtibutes {
        dic[NSAttributedString.Key.baselineOffset] = blo
        return self
    }
    
    @discardableResult
    public func link(_ url: String) -> DNArrtibutes {
        dic[NSAttributedString.Key.link] = url
        return self
    }
    
    @discardableResult
    public func underlineStyle(_ style: NSUnderlineStyle) -> DNArrtibutes {
        dic[NSAttributedString.Key.underlineStyle] = style.rawValue
        return self
    }
    
    @discardableResult
    public func underlineColor(_ color: UIColor) -> DNArrtibutes {
        dic[NSAttributedString.Key.underlineColor] = color
        return self
    }
    
    @discardableResult
    public func shadow(_ shadowOjc: NSShadow) -> DNArrtibutes {
        dic[NSAttributedString.Key.shadow] = shadowOjc
        return self
    }
}
