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
//            if result {
                NotificationCenter.default.post(name: NSNotification.Name(kRegisterUser),
                                                object: nil,
                                                userInfo: nil)
//            }
            print("Go23WalletSDK.auth === \(result)")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

