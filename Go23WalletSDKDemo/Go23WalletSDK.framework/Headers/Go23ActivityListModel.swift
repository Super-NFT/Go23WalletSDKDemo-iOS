//
//  Go23ActivityListModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2023/1/2.
//

import UIKit

public struct Go23ActivityListModel: Codable {
    @DecodableDefault.EmptyList public var listModel: [Go23ActivityModel]
    @DecodableDefault.Zero      public var page: Int
    @DecodableDefault.Zero      public var pageSize: Int
    
    enum CodingKeys: String, CodingKey {
        case listModel = "list"
        case page
        case pageSize = "page_size"
    }
}
