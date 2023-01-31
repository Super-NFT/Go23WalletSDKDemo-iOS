//
//  ArcadeOAuthNetwork.swift
//  Coins
//
//  Created by Taran on 2023/1/12.
//  Copyright © 2023 Global Commerce Technologies Pte. All rights reserved.
//

import UIKit
import SwiftyJSON

class ArcadeOAuthNetwork: NSObject {
    
    static func getThirdAccountInfo(with clientId: String, completion: @escaping ((AuthClientInfo?, String) -> Void) ) {
        let networkShared = Go23NetworkManager.shared
        networkShared.getRequest(URLString: "https://serv4.be.test.dbytothemoon.com/api/oauth2/client", parameters: ["client_id": clientId]) { (response) in
            switch response {
            case .success(let data):
                let responseData = SwiftyJSON.JSON(data)
                let code = responseData["code"].intValue
                let msg = responseData["message"].stringValue
                switch code {
                case -10301:
                    completion(nil, msg)
                case -1:
//                    Go23NetworkManager.shared.getUserToken {}
                    completion(nil, msg)
                case 0:
                    let authinfo = AuthClientInfo(with: SwiftyJSON.JSON(data))
                    completion(authinfo, msg)
                default:
                    completion(nil, msg)
                }
            case .failure:
                let alert = Go23Toast.init(frame: .zero)
                alert.show("Get Third Account Info failed!", after: 1)
            }
        }
    }

    // swiftlint: disable function_parameter_count
    static func getOAuthCode(with scope: String,
                             clientId: String,
                             walletClientId: String,
                             walletClientSecret: String,
                             uniqueId: String,
                             responseType: String = "code",
                             completion: @escaping ((AuthCodeInfo?, String) -> Void)) {
        let params = ["scope": scope,
                      "client_id": clientId,
                      "wallet_client_id": walletClientId,
                      "wallet_client_secret": walletClientSecret,
                      "unique_id": uniqueId,
                      "response_type": responseType]
        let networkShared = Go23NetworkManager.shared
        networkShared.getRequest(URLString: "https://serv4.be.test.dbytothemoon.com/api/oauth2/authorize_direct",
                                  parameters: params) { (response) in
            switch response {
            case .success(let data):
                let responseData = SwiftyJSON.JSON(data)
                let code = responseData["code"].intValue
                let msg = responseData["message"].stringValue
                switch code {
                case -10301:
                    completion(nil, msg)
                case -1:
//                    Go23NetworkManager.shared.getUserToken {}
                    completion(nil, msg)
                case 0:
                    let authcode = AuthCodeInfo(with: SwiftyJSON.JSON(data))
                    completion(authcode, msg)
                default:
                    completion(nil, msg)
                }
            case .failure:
                let alert = Go23Toast.init(frame: .zero)
                alert.show("Get Auth failed!", after: 1)

            }
        }
    }
}
