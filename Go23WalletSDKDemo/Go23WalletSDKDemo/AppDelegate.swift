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
        let vc = Go23TabBarController()
        vc.view.backgroundColor = .white
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    
}

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if UIApplication.shared.canOpenURL(url) {
            parseOAuth(with: url)
            return true
        }
        return false
    }
    
    private func parseOAuth(with url: URL) {
        guard let urlComponents = URLComponents(string: url.absoluteString),
              let queryItems = urlComponents.queryItems,
              let parameters = dictFromQueryItems(queryItems),
              let scope = parameters["scope"],
              let clientId = parameters["client_id"]
        else {
            let totast = Go23Toast.init(frame: .zero)
            totast.show("Coins Auth failed!", after: 1)
            return
        }
        Go23WalletMangager.shared.scope = scope
        Go23WalletMangager.shared.clientId = clientId
        NotificationCenter.default.post(name: NSNotification.Name("oauthPost"),
                                        object: ["scope": scope, "clientId": clientId],
                                        userInfo: nil)
        

        
    }
    
    private func dictFromQueryItems(_ items: [URLQueryItem]) -> [String: String]? {
        var parameters = [String: String]()
        items.forEach { item in
            let key = item.name
            let value = item.value
            parameters[key] = value
        }
        if parameters.count == 0 { return nil }
        return parameters
    }
    
    
}

