//
//  UIViewExtension.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/5.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            layerMaskedCorner(CACornerMask(rawValue: corners.rawValue), radius: radius)
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    @available(iOS 11.0, *)
    func layerMaskedCorner(_ maskedCorners: CACornerMask, radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
}


func currentViewController() -> (UIViewController?) {
   var window = UIApplication.shared.keyWindow
   if window?.windowLevel != UIWindow.Level.normal{
     let windows = UIApplication.shared.windows
     for  windowTemp in windows{
       if windowTemp.windowLevel == UIWindow.Level.normal{
          window = windowTemp
          break
        }
      }
    }
   let vc = window?.rootViewController
   return currentViewController(vc)
}


func currentViewController(_ vc :UIViewController?) -> UIViewController? {
   if vc == nil {
      return nil
   }
   if let presentVC = vc?.presentedViewController {
      return currentViewController(presentVC)
   }
   else if let tabVC = vc as? UITabBarController {
      if let selectVC = tabVC.selectedViewController {
          return currentViewController(selectVC)
       }
       return nil
    }
    else if let naiVC = vc as? UINavigationController {
       return currentViewController(naiVC.visibleViewController)
    }
    else {
       return vc
    }
 }


