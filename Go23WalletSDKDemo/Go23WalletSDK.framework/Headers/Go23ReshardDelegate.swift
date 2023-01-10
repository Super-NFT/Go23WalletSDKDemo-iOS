//
//  Go23ReshardProtocol.swift
//  Go23SDKCode
//
//  Created by Taran on 2023/1/9.
//

import UIKit

// normal reshard will verify pincode
// forget pincode will verify email code, if success, then reshard and set pincode
public protocol Go23ReshardDelegate: Go23SetPincodeDelegate, Go23VerifyPincodeDelegate {
    func reshardWillStart()
    func reshardDidEnd()
}
