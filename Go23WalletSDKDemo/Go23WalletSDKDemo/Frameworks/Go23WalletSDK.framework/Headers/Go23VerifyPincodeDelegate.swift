//
//  Go23VerifyPincodeDelegate.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/10.
//

import UIKit

public protocol Go23VerifyPincodeDelegate: NSObject {
    func verifyPincodePageWillShow() // Called when the verify pincode view is about to made visible. Default does nothing
    func verifyPincodePageWillDismiss() // Called when the verify pincode view is dismissed, covered or otherwise hidden. Default does nothing
}

extension Go23VerifyPincodeDelegate {
    
    func verifyPincodePageWillShow() {}
    func verifyPincodePageWillDismiss() {}
}
