//
//  GO23NFTAttribute.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/10.
//

import UIKit

public struct Go23NFTAttribute: Codable{
    @DecodableDefault.EmptyString public var traitType: String
    @DecodableDefault.EmptyString public var value: String
    
    enum CodingKeys: String, CodingKey {
        case traitType = "trait_type"
        case value
    }
}
