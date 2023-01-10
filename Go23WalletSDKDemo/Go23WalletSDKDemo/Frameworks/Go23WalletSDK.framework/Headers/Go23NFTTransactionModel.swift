//
//  Go23NFTTransactionModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/26.
//

import UIKit

public struct Go23NFTTransactionModel: Codable {
    @DecodableDefault.False       public var isOk: Bool
    @DecodableDefault.EmptyString public var gas: String
    
    enum CodingKeys: String, CodingKey {
        case isOk = "is_ok"
        case gas
    }
}
