//
//  Go23WalletListModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/9.
//

public struct Go23WalletListModel: Codable {
    
    @DecodableDefault.EmptyList public var walletList: [Go23WalletInfoModel]
    
    enum CodingKeys: String, CodingKey {
        case walletList = "data"
    }
}
