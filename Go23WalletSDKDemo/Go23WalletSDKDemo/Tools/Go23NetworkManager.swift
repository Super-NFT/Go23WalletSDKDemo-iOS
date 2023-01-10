//
//  Go23NetworkManager.swift
//  Go23WalletSDKDemo
//
//  Created by luming on 2022/12/27.
//

import Foundation
import Alamofire


final class Go23NetworkManager: NSObject {
    
    static var shared = Go23NetworkManager()
    var netWorkHeader = ["Content-Type": "application/json"]
    
    private override init() {
        super.init()
    }
    
    override func copy() -> Any {
        return self
    }
        
    override func mutableCopy() -> Any {
        return self
    }
    
    func setNetworkHeader(with key: String, value: String) {
        self.netWorkHeader[key] = value
    }
}

extension Go23NetworkManager {
    
    func getRequest(URLString url: String,
                    parameters: [String: Any]?,
                    callback: @escaping (Swift.Result<Any, Error>) -> Void) {
        Go23NetworkLayer.sendRequest(with: .GET, URLString: url, parameters: parameters, headers: self.netWorkHeader) { [weak self] result in
            switch result {
            case .success(let data):
                callback(.success(data))
            case .failure(let err):
                callback(.failure(err))
            }
        }
    }
    
    func postRequest(URLString url: String,
                     parameters: [String: Any]?,
                     callback: @escaping (Swift.Result<Any, Error>) -> Void) {
        Go23NetworkLayer.sendRequest(with: .POST, URLString: url, parameters: parameters, headers: self.netWorkHeader) { [weak self] result in
            switch result {
            case .success(let data):
                callback(.success(data))
            case .failure(let err):
                callback(.failure(err))
            }
        }
    }
}

enum HTTPMethodType {
    case GET
    case POST
    case DELETE
    case PUT
    
    func alamofireMethod() -> HTTPMethod {
        switch self {
        case .GET:
            return HTTPMethod.get
        case .POST:
            return HTTPMethod.post
        case .DELETE:
            return HTTPMethod.delete
        case .PUT:
            return HTTPMethod.put
        }
    }
    
    func urlEncoding() -> ParameterEncoding {
        switch self {
        case .GET:
            return URLEncoding.queryString
        case .POST, .DELETE, .PUT:
            return JSONEncoding.default        }
    }
}

// ------------------------------------------------------
let Go23HostDemo = "https://api.go23.test.dbytothemoon.com"

// MARK: Network Layer
final class Go23NetworkLayer {
    class func sendRequest(with methodType: HTTPMethodType,
                               URLString url: String,
                               parameters: [String: Any]? = nil,
                               headers: [String: String]? = nil,
                               finishedCallback: @escaping (Swift.Result<Any, Error>) -> Void) {
        
        let method = methodType.alamofireMethod()
        let urlencode = methodType.urlEncoding()
        
        var urlString = url
        if urlString.hasPrefix("https") == false {
            urlString = Go23HostDemo + urlString
        }
        
        Alamofire.request(urlString,
                          method: method,
                          parameters: parameters,
                          encoding: urlencode,
                          headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                finishedCallback(.success(json))
            case .failure(let error):
                finishedCallback(.failure(error))
            }
        }
    }
}
 

