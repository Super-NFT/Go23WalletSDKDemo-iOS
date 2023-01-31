//
//  ArcadeOAuthManager.swift
//  Coins
//
//  Created by Taran on 2023/1/12.
//  Copyright © 2023 Global Commerce Technologies Pte. All rights reserved.
//

import UIKit

class ArcadeOAuthManager: NSObject {
    static let `default` = ArcadeOAuthManager()
    let arcadeOAuthKey = "arcadeOAuthKey"
    
    var scope = ""
    var clientId = ""
    // auth return code
    var authCode = ""
    
    private override init() {
        
    }
    
    func isAuthed() -> Bool {
        return getOAuthStatus(with: clientId)
    }
    
    func authCallback(with code: String) {
        setOAuthedStatus(with: clientId)
        if let url = URL(string: "go\(clientId)://coins-oauth?code=\(code)&msg=success") {
            UIApplication.shared.open(url)
        }
    }
    
    func cancelAuthCallback() {
        if let url = URL(string: "go\(clientId)://coins-oauth?code=-1&msg=calcel_auth") {
            UIApplication.shared.open(url)
        }
    }
    
    func authFailed(with msg: String) {
        if let url = URL(string: "go\(clientId)://coins-oauth?code=-1&msg=\(msg)") {
            UIApplication.shared.open(url)
        }
    }
}

extension ArcadeOAuthManager {
    
    private func setOAuthedStatus(with clientId: String) {
        UserDefaults.standard.set(true, forKey: arcadeOAuthKey + clientId)
    }
    
    private func getOAuthStatus(with clientId: String) -> Bool {
        guard let status = UserDefaults.standard.value(forKey: arcadeOAuthKey + clientId) as? Bool else {
            return  false
        }
        
        return status
    }
}
