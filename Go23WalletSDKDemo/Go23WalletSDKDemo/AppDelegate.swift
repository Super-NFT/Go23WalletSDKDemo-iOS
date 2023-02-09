//
//  AppDelegate.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/2.
//

import UIKit
import Go23SDK

@main

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Replace yout appKey and secretKey here.
        //release
//        Go23WalletSDK.auth(appKey: "OcHB6Ix8bIWiOyE35ze6Ra9e",
//                           secretKey: "KX6OquHkkKQmzLSncmnmNt2q") { result in
//            if result {
//                NotificationCenter.default.post(name: NSNotification.Name(kRegisterUser),
//                                                object: nil,
//                                                userInfo: nil)
//            }
//            print("Go23WalletSDK.auth === \(result)")
//        }
        
        //debug
        Go23WalletSDK.auth(appKey: "j9ASxn5REHG8akytevRYZwCp",
                           secretKey: "QHXFT28Nu1u4R7IiGBlFCVXF") { result in
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

