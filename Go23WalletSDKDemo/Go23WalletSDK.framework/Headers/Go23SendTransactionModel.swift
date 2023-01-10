//
//  Go23WalletTransactionModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/7.
//

import Foundation

public struct Go23SendTransactionModel {
    var type: Int
    var rpc: String
    var chainId: Int
    var fromAddr: String
    var toAddr: String
    var transType: Int
    var contractAddress: String
    var tokenId: String
    var value: String
    var middleContractAddress: String
    var decimal: Int
    var nftName: String
    var tokenIcon: Data?
    var chainName: String
    
    public init(type: Int,
                rpc: String,
                chainId: Int,
                fromAddr: String,
                toAddr: String,
                transType: Int,
                contractAddress: String,
                tokenId: String,
                value: String,
                middleContractAddress: String,
                decimal: Int,
                nftName: String,
                tokenIcon: Data? = nil,
                chainName: String) {
        self.type = type
        self.rpc = rpc
        self.chainId = chainId
        self.fromAddr = fromAddr
        self.toAddr = toAddr
        self.transType = transType
        self.contractAddress = contractAddress
        self.tokenId = tokenId
        self.value = value
        self.middleContractAddress = middleContractAddress
        self.decimal = decimal
        self.nftName = nftName
        self.tokenIcon = tokenIcon
        self.chainName = chainName
    }
}
