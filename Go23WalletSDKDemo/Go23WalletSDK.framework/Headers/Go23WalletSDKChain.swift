//
//  Go23SDKChain.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/20.
//

import UIKit

// MARK: Chain
extension Go23WalletSDK {
    
    public func addChain(with address: String,
                         chainId: Int,
                         completion: @escaping ((Go23AddChainResult) -> Void)) {
        Go23SDKManager.shared.addChain(with: address,
                                       chainId: chainId,
                                       completion: completion)
    }

    public func removeChain(with address: String,
                            chainId: Int,
                            completion: @escaping ((Go23RemoveChainResult) -> Void)) {
        Go23SDKManager.shared.removeChain(with: address,
                                          chainId: chainId,
                                          completion: completion)
    }
    
    public func setCurrentChain(with address: String,
                                chainId: Int,
                                completion: @escaping ((Go23SetCurrentChainResult) -> Void)) {
        Go23SDKManager.shared.setCurrentChain(with: address,
                                              chainId: chainId,
                                              completion: completion)
    }
    
    public func fetchWalletChainlist(with address: String,
                                     pageSize: Int,
                                     pageNumber: Int,
                                     completion: @escaping ((Go23WalletChainListModel?) -> Void)) {
        Go23SDKManager.shared.fetchWalletChainlist(with: address,
                                                   pageSize: pageSize,
                                                   pageNumber: pageNumber,
                                                   completion: completion)
    }
    
    public func getChainTokenBalance(with address: String,
                                     chainId: Int,
                                     completion: @escaping ((Go23TokenBalanceModel?) -> Void)) {
        Go23SDKManager.shared.getChainTokenBalance(with: address,
                                                   chainId: chainId,
                                                   completion: completion)
    }
}
