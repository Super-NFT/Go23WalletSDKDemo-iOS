//
//  Go23TabBarController.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/30.
//

import UIKit

class Go23TabBarController: UITabBarController {

    override func viewDidLoad() {
            super.viewDidLoad()
            
            setupItemTitleTextAttributes();
            setupChildViewControllers()
        }
        
        func setupItemTitleTextAttributes() {
            let normalColor = UIColor.rdt_HexOfColor(hexString: "#848484")
            let selectColor = UIColor.rdt_HexOfColor(hexString: "#848484")
            setTabBarColor(normalColor, selectColor, .white)
        }
        
        func setupChildViewControllers() {
            let alert = Go23Toast.init(frame: .zero)
            alert.show("2222 ++ ", after: 1)
            setupOneChildViewController(childVC: Go23HomeViewController(), title: "Wallet", image: "tab1", selectedImage: "tab1_select")
            setupOneChildViewController(childVC: Go23DappViewController(), title: "Dapp", image: "tab2", selectedImage: "tab2_select")
            setupOneChildViewController(childVC: Go23MeViewController(), title: "Me", image: "tab3", selectedImage: "tab3_select")
        }
        
        fileprivate func setupOneChildViewController(childVC:UIViewController,title:String,image:String,selectedImage:String) {
            childVC.tabBarItem.title = title;
            if (image.count>0) {
                childVC.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
                childVC.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
            }
            let nav = UINavigationController.init(rootViewController: childVC)
            self.addChild(nav)
        }
    }

    func setTabBarColor(_ normalColor:UIColor,_ selectColor:UIColor,_ bgColor:UIColor?) {
        let tabBarItem = UITabBarItem.appearance()
        
        var normalAttrs = Dictionary<NSAttributedString.Key,Any>()
        normalAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10)
        normalAttrs[NSAttributedString.Key.foregroundColor] = normalColor
        var selectedAttrs = Dictionary<NSAttributedString.Key,Any>()
        selectedAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10)
        selectedAttrs[NSAttributedString.Key.foregroundColor] = selectColor
        
        tabBarItem.setTitleTextAttributes(normalAttrs, for: .normal)
        tabBarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
        
        if #available(iOS 13.0, *) {
            UITabBar.appearance().unselectedItemTintColor = normalColor
//            UITabBar.appearance().shadowImage = UIColor.white.toUIImage(size: CGSizeMake(ScreenWidth, 1))
        }
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance();
            if (bgColor != nil) {
                appearance.backgroundColor = bgColor;
            }
//            appearance.shadowImage = UIColor.white.toUIImage(size: CGSizeMake(ScreenWidth, 1))
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs;
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs;
            UITabBar.appearance().standardAppearance = appearance;
            UITabBar.appearance().scrollEdgeAppearance = appearance;
        }
}


extension UIColor {
    func toUIImage(size: CGSize) -> UIImage?{
        let width = size.width
        let height = size.height
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
 
        guard let cgImage = image?.cgImage else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
