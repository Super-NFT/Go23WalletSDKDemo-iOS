//
//  Go23WalletSDKToken.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/20.
//

import UIKit

// MARK: Token
extension Go23WalletSDK {

    public func getWalletTokenList(with address: String,
                                   chainId: Int,
                                   pageSize: Int,
                                   pageNumber: Int,
                                   completion: @escaping ((Go23WalletTokenListModel?) -> Void))  {
        Go23SDKManager.shared.getWalletTokenList(with: address,
                                                 chainId: chainId,
                                                 pageSize: pageSize,
                                                 pageNumber: pageNumber,
                                                 completion: completion)
    }
    
    public func getChainTokenList(with chainId: Int,
                                  pageSize: Int,
                                  pageNumber: Int,
                                  completion: @escaping ((Go23ChainTokenListModel?) -> Void))  {
        Go23SDKManager.shared.getChainTokenList(with: chainId,
                                                pageSize: pageSize,
                                                pageNumber: pageNumber,
                                                completion: completion)
    }
    
    public func getTokenBalance(for tokenAddress: String,
                                walletAddress: String,
                                chainId: Int,
                                completion: @escaping ((Go23TokenBalanceModel?) -> Void)) {
        Go23SDKManager.shared.getTokenBalance(for: tokenAddress,
                                              walletAddress: walletAddress,
                                              chainId: chainId,
                                              completion: completion)
    }
    
    public func getTokenDetail(for chainId: Int,
                               tokenAddress: String,
                               completion: @escaping ((Go23TokenDetailModel?) -> Void)) {
        Go23SDKManager.shared.getTokenDetail(for: chainId,
                                             tokenAddress: tokenAddress,
                                             completion: completion)
    }
    
    public func checkToken(with address: String,
                           chainId: Int,
                           completion: @escaping ((Go23ChainTokenInfoModel?) -> Void)) {
        Go23SDKManager.shared.checkToken(with: address,
                                         chainId: chainId,
                                         completion: completion)
    }
    
    public func addToken(with chainId: Int,
                         walletAddress: String,
                         contractAddress: String,
                         completion: @escaping ((Bool) -> Void)) {
        Go23SDKManager.shared.addToken(with: chainId,
                                       walletAddress: walletAddress,
                                       contractAddress: contractAddress,
                                       completion: completion)
    }
    
    public func hideToken(with chainId: Int,
                          walletAddress: String,
                          contractAddress: String,
                          completion: @escaping ((Bool) -> Void)) {
        Go23SDKManager.shared.hideToken(with: chainId,
                                        walletAddress: walletAddress,
                                        contractAddress: contractAddress,
                                        completion: completion)
    }
}
