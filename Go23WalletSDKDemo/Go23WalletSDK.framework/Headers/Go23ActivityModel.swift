//
//  Go23ActivityModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/16.
//

public struct Go23ActivityModel: Codable {
    @DecodableDefault.Zero        public var transactionId: Int
    @DecodableDefault.Zero        public var chainId: Int
    @DecodableDefault.EmptyString public var hash: String
    @DecodableDefault.EmptyString public var contract: String
    @DecodableDefault.EmptyString public var fromAddr: String
    @DecodableDefault.EmptyString public var toAddr: String
    @DecodableDefault.EmptyString public var type: String
    @DecodableDefault.EmptyString public var token: String
    @DecodableDefault.EmptyString public var value: String
    @DecodableDefault.Zero        public var nonce: Int
    @DecodableDefault.EmptyString public var gasPrice:String
    @DecodableDefault.Zero        public var gasLimit: Int
    @DecodableDefault.EmptyString public var time: String
    @DecodableDefault.Zero        public var status: Int
    @DecodableDefault.EmptyString public var symbol: String
    @DecodableDefault.EmptyString public var transactionType: String
    @DecodableDefault.EmptyString public var balanceU: String
    @DecodableDefault.EmptyString public var walletAddr: String
    
    enum CodingKeys: String, CodingKey {
        case transactionId = "transaction_id"
        case chainId = "chain_id"
        case hash
        case contract
        case fromAddr = "from_addr"
        case toAddr = "to_addr"
        case type
        case token
        case value
        case nonce
        case gasPrice = "gas_price"
        case gasLimit = "gas_limit"
        case time
        case status
        case symbol
        case transactionType = "transaction_type"
        case balanceU = "balance_u"
        case walletAddr = "wallet_addr"
    }
}
