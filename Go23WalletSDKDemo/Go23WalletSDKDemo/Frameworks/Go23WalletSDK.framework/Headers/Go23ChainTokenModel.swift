//
//  Go23ChainTokenModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/20.
//

public struct Go23ChainTokenModel: Codable {
    @DecodableDefault.EmptyString public var contractAddress: String
    @DecodableDefault.Zero        public var chainId: Int
    @DecodableDefault.EmptyString public var name: String
    @DecodableDefault.EmptyString public var symbol: String
    @DecodableDefault.False       public var isSelected: Bool
    @DecodableDefault.False       public var isPlatform: Bool
    @DecodableDefault.EmptyString public var imageUrl: String
    @DecodableDefault.EmptyString public var chainImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case contractAddress = "contract_address"
        case chainId = "chain_id"
        case name
        case symbol
        case isSelected = "is_selected"
        case isPlatform = "is_platform"
        case imageUrl = "image_url"
        case chainImageUrl = "chain_image_url"
    }
}
