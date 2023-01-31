//
//  AuthClientInfo.swift
//  Coins
//
//  Created by Taran on 2023/1/14.
//  Copyright © 2023 Global Commerce Technologies Pte. All rights reserved.
//

import UIKit
import SwiftyJSON

struct AuthClientInfo {
    
    var avatar: String = ""
    var clientId: String = ""
    var clientName: String = ""
    
    init(with jsonData: SwiftyJSON.JSON) {
        let data = jsonData["data"].dictionaryValue
        if let avatar = data["avatar"]?.stringValue {
            self.avatar = avatar
        }
        
        if let clientId = data["client_id"]?.stringValue {
            self.clientId = clientId
        }
        
        if let clientName = data["client_name"]?.stringValue {
            self.clientName = clientName
        }
    }
}

struct AuthCodeInfo {
    var code: String = ""
    
    init(with jsonData: SwiftyJSON.JSON) {
        let data = jsonData["data"].dictionaryValue
        if let code = data["code"]?.stringValue {
            self.code = code
        }
    }

}
