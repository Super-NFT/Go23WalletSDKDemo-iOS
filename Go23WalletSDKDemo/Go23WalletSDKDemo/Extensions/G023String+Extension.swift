//
//  StringExtension.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/5.
//

import Foundation
import UIKit

extension String {

    subscript (i:Int)->String{
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let endIndex = self.index(startIndex, offsetBy: 1)
        return String(self[startIndex..<endIndex])
    }

    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    subscript (index:Int , length:Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length)
            return String(self[startIndex..<endIndex])
        }
    }
    
    func substring(to:Int) -> String{
        return self[0..<to]
    }
    
    func substring(from:Int) -> String{
        return self[from..<self.count]
    }
    
    func toPercentEncodingStr() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    
    static func getSecretString(token: String) -> String {
        var str = ""
        if token.count > 8 {
            str.append(token.substring(to: 5))
        } else {
            return token
        }
        str.append("...")
        if token.count > 8 {
            str.append(token.substring(from: token.count-4))
        }
        
        return str
    }
    
    static func getSubSecretString(_ length:Int = 5, string: String)-> String {
        var str = ""
        if string.count > 12 {
            str.append(string.substring(to: length))
        } else {
            return string
        }
        str.append("...")
        if string.count > 12 {
            str.append(string.substring(from: string.count-length))
        }
        
        return str
    }
    
    static func getAttributeString(font: UIFont?, wordspace: Float, color: UIColor?, alignment: NSTextAlignment = .left, title: String)->NSAttributedString {
        let paraph = NSMutableParagraphStyle()
        paraph.lineSpacing = 0
        paraph.alignment = alignment 
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14), NSAttributedString.Key.kern: wordspace, NSAttributedString.Key.foregroundColor:color ?? UIColor.black] as [NSAttributedString.Key : Any]
        let attri = NSAttributedString(string: title, attributes: attributes as [NSAttributedString.Key : Any])
        return attri
    }
    
    
    static func getStringWidth(_ content: String,
                                 lineHeight:CGFloat = 27.0,
                                 font: UIFont = UIFont.systemFont(ofSize: 14),
                                 wordWidth: CGFloat = (ScreenWidth - 40.0)) -> CGFloat {
        let paraph = NSMutableParagraphStyle()
        paraph.maximumLineHeight = lineHeight
        paraph.minimumLineHeight = lineHeight
//            paraph.alignment = .justified
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph, NSAttributedString.Key.font: font, NSAttributedString.Key.kern: 0.5] as [NSAttributedString.Key : Any]

        let rowHeight = (content.trimmingCharacters(in: .newlines) as NSString).boundingRect(with: CGSize(width: wordWidth, height: 0), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: attributes, context: nil).size.width
         return rowHeight
     }
}
