//
//  Go23SetPincodeDelegate.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/10.
//

import UIKit

public protocol Go23SetPincodeDelegate: NSObject {
    func setPincodePageWillShow() // Called when the set pincode view is about to made visible. Default does nothing
    func setPincodePageWillDismiss() // Called when the set pincode view is dismissed, covered or otherwise hidden. Default does nothing
}

extension Go23SetPincodeDelegate {
    func setPincodePageWillShow() {}
    func setPincodePageWillDismiss() {}
}
