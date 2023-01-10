//
//  Go23NFTDetailModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

public struct Go23NFTDetailModel: Codable {
    @DecodableDefault.EmptyString public var tokenId: String
    @DecodableDefault.EmptyString public var walletAddress: String
    @DecodableDefault.EmptyString public var contractAddress: String
    @DecodableDefault.Zero        public var chainId: Int
    @DecodableDefault.EmptyString public var chainName: String
    @DecodableDefault.EmptyString public var externalUrl: String
    @DecodableDefault.EmptyString public var name: String
    @DecodableDefault.EmptyString public var image: String
    @DecodableDefault.EmptyString public var animationUrl: String
    @DecodableDefault.EmptyString public var desc: String
    @DecodableDefault.EmptyList   public var attributes: [Go23NFTAttribute]
    @DecodableDefault.EmptyString public var series: String
    
    enum CodingKeys: String, CodingKey {
        case tokenId = "token_id"
        case walletAddress = "user_wallet_address"
        case contractAddress = "contract_address"
        case chainId = "chain_id"
        case chainName = "block_chain_name"
        case externalUrl = "external_url"
        case name
        case image
        case animationUrl = "animation_url"
        case desc = "description"
        case attributes
        case series
    }
}
