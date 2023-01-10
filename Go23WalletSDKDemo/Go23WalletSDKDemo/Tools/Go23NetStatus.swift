//
//  Go23NetStatus.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2023/1/9.
//

import UIKit
import Alamofire


protocol Go23NetStatusProtocol {
    func isReachable() -> Bool
}
extension Go23NetStatusProtocol {
    func isReachable() -> Bool {
        var res: Bool = false
        let netManager = NetworkReachabilityManager()
        if netManager?.networkReachabilityStatus == .reachable(.ethernetOrWiFi) {
            return true
        }
        return res
        
    }
}
