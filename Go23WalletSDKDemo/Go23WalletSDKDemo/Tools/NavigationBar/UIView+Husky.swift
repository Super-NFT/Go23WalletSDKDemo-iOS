//
//  UIView+Husky.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import Foundation
import UIKit

public extension UIView {
    var viewController: UIViewController? {
        var responder = next
        repeat {
            if (responder is UIViewController) {
                return responder as? UIViewController
            }
            responder = responder?.next
        } while responder != nil
        return nil
    }
}
