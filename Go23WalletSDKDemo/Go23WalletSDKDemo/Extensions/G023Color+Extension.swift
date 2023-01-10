//
//  ColorExtension.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import Foundation
import UIKit

extension UIColor {
    
   static func rdt_RGBColor(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor {
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha:1.0)
    }
    
   static func rdt_RGBAColor(red:CGFloat, green:CGFloat, blue:CGFloat, aplha:CGFloat) ->UIColor{
        return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: aplha)
    }
    
    @objc static func rdt_HexOfColor(hexString:String, _ alpha: CGFloat = 1.0) -> UIColor {
        var cstr = hexString.trimmingCharacters(in:  CharacterSet.whitespacesAndNewlines).uppercased() as NSString
        if(cstr.length < 6){
            return .clear
        }
        if (cstr.hasPrefix("0X")) {
            cstr = cstr.substring(from:2)as NSString
        }
        if (cstr.hasPrefix("#")) {
            cstr = cstr.substring(from:1)as NSString
        }
        if (cstr.length != 6) {
            return .clear
        }
        var range = NSRange()
        range.location = 0
        range.length = 2
        //red
        let rStr = cstr.substring(with: range)
        //green
        range.location = 2
        let gStr = cstr.substring(with: range)
        //blue
        range.location = 4
        let bStr = cstr.substring(with: range)
        var r :UInt32 = 0x0
        var g :UInt32 = 0x0
        var b :UInt32 = 0x0
        Scanner.init(string: rStr).scanHexInt32(&r)
        Scanner.init(string: gStr).scanHexInt32(&g)
        Scanner.init(string: bStr).scanHexInt32(&b)
        return UIColor(red:CGFloat(r)/255.0, green:CGFloat(g)/255.0, blue:CGFloat(b)/255.0, alpha:alpha)
    }
}

extension UITableViewCell {
    @objc class func reuseIdentifier() -> String {
        return NSStringFromClass(self) as String
    }
    
}

extension UICollectionReusableView {
    @objc class func reuseIdentifier() -> String {
        return NSStringFromClass(self) as String
    }
}

extension UITableViewHeaderFooterView {
    @objc class func reuseIdentifier() -> String {
        return NSStringFromClass(self) as String
    }
}
