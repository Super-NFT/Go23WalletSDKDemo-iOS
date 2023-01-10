//
//  UIViewController+Husky.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import Foundation
import UIKit

extension UIViewController: HDCompatible{
    var navgationBar:HNavgationBar? {
        get {
            for view in self.view.subviews {
                if let bar = view as? HNavgationBar{
                    return bar
                }
            }
            return nil
        }
    }
    
    @discardableResult
    func addBarView() -> HNavgationBar {
        let navgationBar = HNavgationBar.init(self.view)
        return navgationBar
    }
    
    
}
