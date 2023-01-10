//
//  Go23TokenBalanceModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/25.
//

public struct Go23TokenBalanceModel: Codable {
    @DecodableDefault.EmptyString public var balance: String
    @DecodableDefault.EmptyString public var balanceU: String
    
    enum CodingKeys: String, CodingKey {
        case balance
        case balanceU = "balance_u"
    }
}
