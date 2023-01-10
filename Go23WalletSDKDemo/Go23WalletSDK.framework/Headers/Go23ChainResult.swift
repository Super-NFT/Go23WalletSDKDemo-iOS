//
//  Go23ChainResule.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

import Foundation

public enum Go23AddChainError: Error {
    case addError(Int, String)
}

public typealias Go23AddChainResult = Swift.Result<String, Go23AddChainError>


public enum Go23RemoveChainError: Error {
    case removeError(Int, String)
}

public typealias Go23RemoveChainResult = Swift.Result<String, Go23RemoveChainError>


public enum Go23SetCurrentChainError: Error {
    case setChainError(Int, String)
}

public typealias Go23SetCurrentChainResult = Swift.Result<String, Go23SetCurrentChainError>
