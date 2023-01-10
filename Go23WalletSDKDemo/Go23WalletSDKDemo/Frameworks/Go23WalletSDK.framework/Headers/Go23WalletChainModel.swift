//
//  Go23WalletChainModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/7.
//

public struct Go23WalletChainModel: Codable {
    
    @DecodableDefault.EmptyString public var name: String
    @DecodableDefault.Zero        public var chainId: Int
    @DecodableDefault.EmptyString public var walletAddress: String
    @DecodableDefault.False       public var hasDefault: Bool
    @DecodableDefault.EmptyString public var imageUrl: String
    @DecodableDefault.EmptyString public var rpc: String
    @DecodableDefault.EmptyString public var symbol: String
    @DecodableDefault.EmptyString public var middleContractAddress: String

    enum CodingKeys: String, CodingKey {
        case name
        case chainId = "chain_id"
        case walletAddress = "user_wallet_address"
        case hasDefault = "has_default"
        case imageUrl = "image_url"
        case rpc
        case symbol
        case middleContractAddress = "middle_contract_address"
    }
}
