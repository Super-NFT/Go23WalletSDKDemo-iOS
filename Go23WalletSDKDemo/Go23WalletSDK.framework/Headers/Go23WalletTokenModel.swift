//
//  Go23WalletTokenModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/2.
//

public struct Go23WalletTokenModel: Codable {
    @DecodableDefault.EmptyString public var name: String
    @DecodableDefault.EmptyString public var balance: String
    @DecodableDefault.EmptyString public var balanceU: String
    @DecodableDefault.EmptyString public var walletAddr: String
    @DecodableDefault.EmptyString public var contractAddr: String
    @DecodableDefault.Zero        public var chainId: Int
    @DecodableDefault.Zero        public var decimal: Int
    @DecodableDefault.EmptyString public var symbol: String
    @DecodableDefault.EmptyString public var imageUrl: String
    @DecodableDefault.EmptyString public var chainImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case balance
        case balanceU = "balance_u"
        case walletAddr = "user_wallet_address"
        case contractAddr = "contract_address"
        case chainId = "chain_id"
        case decimal
        case symbol
        case imageUrl = "image_url"
        case chainImageUrl = "chain_image_url"
    }
}
