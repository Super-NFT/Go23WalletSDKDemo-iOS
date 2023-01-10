//
//  Go23ActivityDetailModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

public struct Go23ActivityDetailModel: Codable {
    
    @DecodableDefault.Zero        public var status: Int
    @DecodableDefault.EmptyString public var fromAddr: String
    @DecodableDefault.EmptyString public var toAddr: String
    @DecodableDefault.EmptyString public var hash: String
    @DecodableDefault.EmptyString public var network: String
    @DecodableDefault.EmptyString public var type: String
    @DecodableDefault.EmptyString public var amount: String
    @DecodableDefault.EmptyString public var gasFee: String
    @DecodableDefault.EmptyString public var image: String
    @DecodableDefault.EmptyString public var imageName: String
    @DecodableDefault.EmptyString public var token: String
    @DecodableDefault.EmptyString public var time: String
    @DecodableDefault.EmptyString public var symbol: String
    @DecodableDefault.EmptyString public var gasSymbol: String
    @DecodableDefault.Zero        public var transactionClass: Int
    @DecodableDefault.EmptyString public var lendingGasFee: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case fromAddr = "from_addr"
        case toAddr = "to_addr"
        case hash
        case network
        case type
        case amount
        case gasFee = "gas_fee"
        case image
        case imageName = "image_name"
        case token
        case time
        case symbol
        case gasSymbol = "gas_symbol"
        case transactionClass = "transaction_class"
        case lendingGasFee = "lending_gas_fee"
    }
}
