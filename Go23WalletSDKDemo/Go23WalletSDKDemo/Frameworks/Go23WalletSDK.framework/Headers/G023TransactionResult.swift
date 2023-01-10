//
//  G023TransactionResult.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

import Foundation

public enum Go23TransactionError: Error {

}

typealias Go23TransactionResult = Swift.Result<Any, Go23TransactionError>
