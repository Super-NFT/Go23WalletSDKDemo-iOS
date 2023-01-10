//
//  Go23NFTBaseInfoModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

public struct Go23NFTBaseInfoModel: Codable {
    @DecodableDefault.EmptyString public var nftId: String
    @DecodableDefault.EmptyString public var name: String
    @DecodableDefault.EmptyString public var addr: String
    @DecodableDefault.Zero        public var blockChainId: Int
    @DecodableDefault.EmptyString public var chainImageUrl: String
    @DecodableDefault.EmptyString public var url: String
    @DecodableDefault.EmptyString public var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case nftId = "nft_id"
        case name
        case addr
        case blockChainId = "block_chain_id"
        case chainImageUrl = "chain_image_url"
        case url
        case imageUrl = "image_url"
    }
}
