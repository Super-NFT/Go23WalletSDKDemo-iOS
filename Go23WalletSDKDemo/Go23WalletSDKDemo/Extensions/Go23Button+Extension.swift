//
//  ButtonExtension.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/3.
//

import Foundation
import UIKit

enum ButtonEdgeInsetsStyle {
    case imageTop
    case imageLeft
    case imageRight
    case imageBottom
}

extension UIButton {
    func layoutButtonEdgeInsets(style: ButtonEdgeInsetsStyle = .imageLeft, margin: CGFloat) {
        let imageWith : CGFloat = self.imageView?.image?.size.width ?? 0
        let imageHeight : CGFloat = self.imageView?.image?.size.height ?? 0
        
        var labelWidth : CGFloat = 0.0;
        var labelHeight : CGFloat = 0.0;
        if #available(iOS 8.0, *) {
            labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0
            labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0
        } else {
            labelWidth = self.titleLabel?.frame.size.width ?? 0
            labelHeight = self.titleLabel?.frame.size.height ?? 0
        }
        
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        switch style {
        case .imageTop:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-margin/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith, bottom: -imageHeight-margin/2.0, right: 0)
        case .imageLeft:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -margin/2.0, bottom: 0, right: margin/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: margin/2.0, bottom: 0, right: -margin/2.0)
        case .imageBottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-margin/2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-margin/2.0, left: -imageWith, bottom: 0, right: 0)
        case .imageRight:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+margin/2.0, bottom: 0, right: -labelWidth-margin/2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWith-margin/2.0, bottom: 0, right: imageWith+margin/2.0)
        }
        
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}


