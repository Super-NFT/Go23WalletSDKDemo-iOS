//
//  Go23ForgetPincodeProtocol.swift
//  Go23SDKCode
//
//  Created by Taran on 2023/1/9.
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


public protocol Go23VerifyPincodeDelegate: NSObject {
    func verifyPincodePageWillShow() // Called when the verify pincode view is about to made visible. Default does nothing
    func verifyPincodePageWillDismiss() // Called when the verify pincode view is dismissed, covered or otherwise hidden. Default does nothing
}

extension Go23VerifyPincodeDelegate {
    
    func verifyPincodePageWillShow() {}
    func verifyPincodePageWillDismiss() {}
}
