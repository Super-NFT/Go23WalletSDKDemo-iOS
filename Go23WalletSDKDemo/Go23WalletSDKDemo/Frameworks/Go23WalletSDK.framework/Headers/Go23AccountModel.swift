//
//  Go23UserInfoModel.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/8.
//

public enum Go23VerifyCodeType {
    case email(String) // .email("reshare")/ .email("recover")
}

public struct Go23AccountModel: Codable {
    @DecodableDefault.EmptyString public var uuid: String
    
    enum CodingKeys: CodingKey {
        case uuid
    }
}
