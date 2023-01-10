//
//  Go23TokenTransactionModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

public struct Go23TokenTransactionModel: Codable {
    @DecodableDefault.False       public var isLendingGas: Bool
    @DecodableDefault.Zero        public var transType: Int
    @DecodableDefault.EmptyString public var platformBalance: String
    @DecodableDefault.EmptyString public var platformBalanceSort: String
    @DecodableDefault.EmptyString public var platformUPer: String
    @DecodableDefault.EmptyString public var tokenBalance: String
    @DecodableDefault.EmptyString public var tokenBalanceSort: String
    @DecodableDefault.EmptyString public var tokenUPer: String
    @DecodableDefault.EmptyString public var gas: String
    @DecodableDefault.ZeroDouble  public var fee: Double
    @DecodableDefault.Zero        public var decimal: Int
    
    enum CodingKeys: String, CodingKey {
        case isLendingGas = "is_lending_gas"
        case transType = "trans_type"
        case platformBalance = "platform_balance"
        case platformBalanceSort = "platform_balance_sort"
        case platformUPer = "platform_u_per"
        case tokenBalance = "token_balance"
        case tokenBalanceSort = "token_balance_sort"
        case tokenUPer = "token_u_per"
        case gas
        case fee
        case decimal
    }
}

