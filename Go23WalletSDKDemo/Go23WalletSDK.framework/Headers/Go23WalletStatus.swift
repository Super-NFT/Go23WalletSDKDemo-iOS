//
//  Go23WalletStatus.swift
//  Go23WalletSDK
//
//  Created by Taran on 2022/12/9.
//

public enum Go23WalletStatus {
    case none
    case normal([Go23WalletInfoModel])
    case recover([Go23WalletInfoModel])
    case failure(String)
}
