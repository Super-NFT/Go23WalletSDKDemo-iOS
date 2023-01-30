//
//  AppDelegate.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import UIKit
import IQKeyboardManager
import SDWebImageWebPCoder
import CoreTelephony
import Go23SDK

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let WebPCoder = SDImageWebPCoder.shared
        SDImageCodersManager.shared.addCoder(WebPCoder) 
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false

        // Replace yout appKey and secretKey here.
        Go23WalletSDK.auth(appKey: "OcHB6Ix8bIWiOyE35ze6Ra9e",
                           secretKey: "KX6OquHkkKQmzLSncmnmNt2q") { result in
            if result {
                NotificationCenter.default.post(name: NSNotification.Name(kRegisterUser),
                                                object: nil,
                                                userInfo: nil)
            }
            print("Go23WalletSDK.auth === \(result)")
        }
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = Go23HomeViewController()
        vc.view.backgroundColor = .white
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        return true
    }
    
   

}

