//
//  Go23WalletSDKNFT.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/20.
//

import UIKit

// MARK: NFT
extension Go23WalletSDK {
    
    public func getNftDetail(for nftid: String,
                          contractAddress: String,
                          walletAddress: String,
                          chainId: Int,
                          completion: @escaping ((Go23NFTDetailModel?) -> Void)) {
        Go23SDKManager.shared.getNftDetail(for: nftid,
                                           contractAddress: contractAddress,
                                           walletAddress: walletAddress,
                                           chainId: chainId,
                                           completion: completion)
    }

    public func getNftList(with walletAddress: String,
                           chainId: Int,
                           pageSize: Int,
                           pageNumber: Int,
                           completion: @escaping ((Go23WalletNFTListModel?) -> Void)) {
        Go23SDKManager.shared.getNftList(with: walletAddress,
                                         chainId: chainId,
                                         pageSize: pageSize,
                                         pageNumber: pageNumber,
                                         completion: completion)
    }
    
    public func addNFT(with contractAddress: String,
                       walletAddress: String,
                       chainId: Int,
                       completion: @escaping ((Bool) -> Void)) {
        Go23SDKManager.shared.addNFT(with: contractAddress,
                                     walletAddress: walletAddress,
                                     chainId: chainId,
                                     completion: completion)
    }
}
