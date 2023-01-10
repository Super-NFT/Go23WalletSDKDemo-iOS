//
//  Go23ChainTokenInfoModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/2.
//

public struct Go23ChainTokenInfoModel: Codable {
    @DecodableDefault.EmptyString public var contractAddress: String
    @DecodableDefault.Zero        public var chainId: Int
    @DecodableDefault.EmptyString public var name: String
    @DecodableDefault.Zero        public var decimal: Int
    @DecodableDefault.EmptyString public var symbol: String
    
    enum CodingKeys: String, CodingKey {
        case contractAddress = "contract_address"
        case chainId = "chain_id"
        case name
        case decimal
        case symbol
    }
}
