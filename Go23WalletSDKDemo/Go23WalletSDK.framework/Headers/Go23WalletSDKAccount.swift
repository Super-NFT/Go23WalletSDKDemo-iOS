//
//  Go23WalletSDKAccount.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/20.
//

import UIKit

// MARK: Account
extension Go23WalletSDK {
    
    public func connect(with uniqueId: String,
                        email: String,
                        phone: String = "",
                        delegate: Go23ConnectDelegate?,
                        completion: @escaping ((Go23AccountResult) -> Void)) {
        Go23SDKManager.shared.connect(with: uniqueId,
                                      email: email,
                                      phone: phone,
                                      delegate: delegate,
                                      completion: completion)
    }
}
