//
//  Go23AccountResult.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

import Foundation

public enum Go23AccountConnectError: Error {
    case walletCreateFailed(String)
    case networkError(Int, String)
    case accountError(Int, String)
    case walletError(Int, String)
}

public enum Go23AccountConnectSuccess {
    case wallets([Go23WalletInfoModel])
    case recover([Go23WalletInfoModel])
    case walletCreated(String, String) // address, private key shard
}

public typealias Go23AccountResult = Swift.Result<Go23AccountConnectSuccess, Go23AccountConnectError>
