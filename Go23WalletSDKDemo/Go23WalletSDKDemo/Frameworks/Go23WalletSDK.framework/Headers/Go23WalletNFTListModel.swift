//
//  Go23WalletNFTModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/12.
//

public struct Go23WalletNFTListModel: Codable {
    @DecodableDefault.EmptyList public var listModel: [Go23WalletNFTModel]
    @DecodableDefault.Zero      public var page: Int
    @DecodableDefault.Zero      public var pageSize: Int
    
    enum CodingKeys: String, CodingKey {
        case listModel = "list"
        case page
        case pageSize = "page_size"
    }
}
