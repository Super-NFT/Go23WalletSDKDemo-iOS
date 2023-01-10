//
//  Go23WalletSDKTransaction.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/20.
//

import UIKit

// MARK: Transaction
extension Go23WalletSDK {
    
    public func sendTransaction(with model: Go23SendTransactionModel,
                                completion: @escaping ((Bool, String) -> Void)) {
        Go23SDKManager.shared.sendTransaction(with: model,
                                              completion: completion)
    }

    public func getTokenTransactionInfo(for contract: String,
                                        chainId: Int,
                                        from address: String,
                                        completion: @escaping ((Go23TokenTransactionModel?) -> Void)) {
        Go23SDKManager.shared.getTokenTransactionInfo(for: contract,
                                                      chainId: chainId,
                                                      from: address,
                                                      completion: completion)
    }
    
    public func getNFTTransactionInfo(for chainId: Int,
                                      from address: String,
                                      completion: @escaping ((Go23TokenTransactionModel?) -> Void)) {
        Go23SDKManager.shared.getNFTTransactionInfo(for: chainId,
                                                    from: address,
                                                    completion: completion)
    }
    
    public func getActivityList(with chainId: Int,
                                contract: String,
                                walletAddress: String,
                                type: Go23ActivityFilterType,
                                pageNumber: Int,
                                pageSize: Int,
                                completion: @escaping ((Go23ActivityListModel?) -> Void)) {
        Go23SDKManager.shared.getActivityList(with: chainId,
                                              contract: contract,
                                              walletAddress: walletAddress,
                                              type: type,
                                              pageNumber: pageNumber,
                                              pageSize: pageSize,
                                              completion: completion)
    }
    
    public func getActivityDetail(with hash: String,
                                  walletAddress: String,
                                  completion: @escaping ((Go23ActivityDetailModel?) -> Void)) {
        Go23SDKManager.shared.getActivityDetail(with: hash,
                                                walletAddress: walletAddress,
                                                completion: completion)
    }
}
