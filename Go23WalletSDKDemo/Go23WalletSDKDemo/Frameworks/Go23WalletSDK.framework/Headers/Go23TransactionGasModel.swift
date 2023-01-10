//
//  Go23TransactionGasModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/2.
//

public struct Go23TransactionGasModel: Codable {
    @DecodableDefault.EmptyString public var suggestGas: String
    
    enum CodingKeys: String, CodingKey {
        case suggestGas = "suggest_gas"
    }
}
