//
//  Go23Net.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/27.
//

import UIKit

class Go23Net {
    static func getServerShard(with addr: String,
                               completion: @escaping ((String?) -> Void)) {
        let params = ["wallet_address": addr]
        Go23NetworkManager.shared.postRequest(URLString: "/merchant/get_keygen", parameters: params) { (response) in
            switch response {
            case .success(let data):
                guard let dict = data as? [String: Any],
                      let datadic = dict["data"] as? [String: Any],
                      let shard = datadic["keygen"] as? String
                else {
                    completion(nil)
                    return
                }
                completion(shard)
            case .failure:
                completion(nil)
            }
        }
    }
    
    static func uploadServerShard(with data: String,
                                   address: String,
                                   completion: @escaping ((Bool) -> Void)) {
        let params = ["wallet_address": address,
                      "keygen": data]
        Go23NetworkManager.shared.postRequest(URLString: "/merchant/create_keygen", parameters: params) { (response) in
            switch response {
            case .success(let data):
                guard let dict = data as? [String: Any],
                      let code = dict["code"] as? Int else {
                    completion(false)
                    return
                }
                if code == 0 {
                    completion(true)
                } else {
                    completion(false)
                }
                
            case .failure:
                completion(false)
            }
        }
    }
    
    static func updateServerShard(with data: String,
                                   address: String,
                                   completion: @escaping ((Bool) -> Void)) {
        
        let params = ["wallet_address": address,
                      "keygen": data]
        Go23NetworkManager.shared.postRequest(URLString: "/merchant/update_keygen", parameters: params) {(response) in
            switch response {
            case .success(let data):
                guard let dict = data as? [String: Any],
                      let code = dict["code"] as? Int else {
                    completion(false)
                    return
                }
                if code == 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
}
