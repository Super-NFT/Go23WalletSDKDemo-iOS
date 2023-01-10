//
//  Go23WalletTokenModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/7.
//

public struct Go23WalletTokenListModel: Codable {
    @DecodableDefault.EmptyList public var listModel: [Go23WalletTokenModel]
    @DecodableDefault.Zero      public var page: Int
    @DecodableDefault.Zero      public var pageSize: Int
    
    enum CodingKeys: String, CodingKey {
        case listModel = "list"
        case page
        case pageSize = "page_size"
    }
}
