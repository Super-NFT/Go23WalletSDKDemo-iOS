//
//  Go23WalletResult.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

import Foundation

// MARK: Go23RestoreResult
public enum Go23RestoreError: Error {
    case errorPincode
    case cancelRecover
    case forgetPincode
    case shardLostError
    case invalidAccount(String)
}
public typealias Go23RestoreResult = Swift.Result<String, Go23RestoreError>


// MARK: Go23ReshardResult
public typealias Go23ShardString = String
public enum Go23ReshardError: Error {
    case shardLost
    case errorPincode
    case forgetPincode
    case cancelReshard
    case reshardFailed
    case networkError(String)
    case invalidAccount(String)
}
public typealias Go23ReshardResult = Swift.Result<Go23ShardString, Go23ReshardError>


// MARK: Go23WalletListResult
public enum Go23WalletListSuccess {
    case wallets([Go23WalletInfoModel])
    case recover([Go23WalletInfoModel])
}

public enum Go23WalletListError: Error {
    case networkError(Int, String)
    case walletError(Int, String)
}

public typealias Go23WalletListResult = Swift.Result<Go23WalletListSuccess, Go23WalletListError>
