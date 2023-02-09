//
//  HConfig.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import Foundation
import UIKit

struct HD<Base>{
    let base: Base
    init(_ base:Base){
        self.base = base
    }
}

protocol HDCompatible{}

extension HDCompatible{
    static var hd: HD<Self>.Type {
        get { return HD<Self>.self }
        set { }
    }
    var hd: HD<Self> {
        get { return HD(self) }
        set { }
    }
}

var HDScreenWidth: CGFloat {
    get{
        return UIScreen.main.bounds.width
    }
}
var HDScreenHeight: CGFloat {
    get{
        return UIScreen.main.bounds.height
    }
}


var HDCurrentWindow: UIWindow? {
    var window: UIWindow?
    if #available(iOS 13.0, *) {
        window = HDCurrentScenes?.windows.first
    }
    window = UIApplication.shared.keyWindow
    return window
}

@available(iOS 13.0, *)
var HDCurrentScenes: UIWindowScene? {
    for scene in UIApplication.shared.connectedScenes {
        if let windowScene = scene as? UIWindowScene , windowScene.activationState == .foregroundActive {
            return windowScene
        }
    }
    return nil
}



struct HApp {
    /// 状态栏高度
    static var appStatusHeight: CGFloat{
        if #available(iOS 13.0, *) {
            if let windowScene = HDCurrentScenes, let barManager = windowScene.statusBarManager {
                return barManager.statusBarFrame.size.height
            }
        }
        return UIApplication.shared.statusBarFrame.size.height
    }
    
    static var appSafeInset: UIEdgeInsets{
        
        if let window = HDCurrentWindow  {
            if #available(iOS 11.0, *) {
                return window.safeAreaInsets
            }
        }
        
        var statusBarOrientation:UIInterfaceOrientation = UIApplication.shared.statusBarOrientation
        
        if #available(iOS 13.0, *) {
            if let windowScene = HDCurrentScenes {
                statusBarOrientation = windowScene.interfaceOrientation
            }
        }
        
        if statusBarOrientation == .landscapeLeft {
            return UIEdgeInsets.init(top: 0, left: appStatusHeight, bottom: 0, right: 0)
        }
        if statusBarOrientation == .landscapeRight {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: appStatusHeight)
        }
        if statusBarOrientation == .portrait {
            return UIEdgeInsets.init(top: appStatusHeight, left: 0, bottom: 0, right: 0)
        }
        if statusBarOrientation == .portraitUpsideDown {
            return UIEdgeInsets.init(top: 0, left: 0, bottom: appStatusHeight, right: 0)
        }
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    static var appNavgationContentHeight:CGFloat{
        return 44;
    }
    
    static var appNavgationBarHeight:CGFloat{
        return appNavgationContentHeight + appStatusHeight;
    }
    
    static var appBottomHeight:CGFloat {
        return appSafeInset.bottom + 49
    }
    
    
    static var appAPixel:CGFloat{
        return 1.0 / UIScreen.main.scale;
    }
}

