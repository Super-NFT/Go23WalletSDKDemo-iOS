//
//  GO23WalletSDK.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/11/13.
//

import Foundation

public class Go23WalletSDK: NSObject {
    
    public static var shared: Go23WalletSDK!
    
    private override init() {
        super.init()
    }
    
    public override func copy() -> Any {
        return self
    }
        
    public override func mutableCopy() -> Any {
        return self
    }
    
    public static func auth(appKey: String,
                            secretKey: String,
                            completion: @escaping ((Bool) -> Void)) {
        Go23SDKManager.auth(appKey: appKey,
                            secretKey: secretKey) { (result, message) in
                            if result {
                                shared = Go23WalletSDK()
                                completion(true)
                            } else {
                                completion(false)
                            }
        }
    }
}

// MARK: Wallet
extension Go23WalletSDK {
    
    public func fetchUserWallets(completion: @escaping ((Go23WalletListResult) -> Void)) {
        Go23SDKManager.shared.fetchUserWallets(completion: completion)
    }
}

// MARK: VerifyCode
extension Go23WalletSDK {
    
    public func sendVerifyCode(for type: Go23VerifyCodeType,
                               completion: @escaping ((Bool) -> Void)) {
        Go23SDKManager.shared.sendVerifyCode(for: type,
                                             completion: completion)
    }
}

// MARK: Reshard and Resore
extension Go23WalletSDK {
    
    // Verify code only used to user forget passowrd reshard.
    public func reshardWallet(with address: String,
                              shard: String,
                              delegate: Go23ReshardDelegate?,
                              completion: @escaping ((Go23ReshardResult) -> Void)) {
        Go23SDKManager.shared.reshardWallet(with: address,
                                            shard: shard,
                                            delegate: delegate,
                                            completion: completion)
    }
    
    public func forgetShardPincode(with address: String,
                                   shard: String,
                                   verifyCode code: String,
                                   delegate: Go23ReshardDelegate?,
                                   completion: @escaping ((Go23ReshardResult) -> Void)) {
        Go23SDKManager.shared.forgetShardPincode(with: address,
                                                 shard: shard,
                                                 verifyCode: code,
                                                 delegate: delegate,
                                                 completion: completion)
    }
    
    public func restoreWallet(with addr: String,
                              verifyCode code: String,
                              delegate: Go23RestoreDelegate?,
                              completion: @escaping ((Go23RestoreResult) -> Void)) {
        Go23SDKManager.shared.restoreWallet(with: addr,
                                            verifyCode: code,
                                            delegate: delegate,
                                            completion: completion)
    }
}

