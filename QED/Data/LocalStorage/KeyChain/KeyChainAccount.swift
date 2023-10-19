//
//  KeyChainAccount.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

enum KeyChainAccount {
    case id
    case name
    case email
    case refreshToken

    // 더 필요한 Account 추가

    var description: String {
        return String(describing: self)
    }

    var keyChainClass: CFString {
        switch self {
        case .id:
            return kSecClassGenericPassword
        case .name:
            return kSecClassGenericPassword
        case .email:
            return kSecClassGenericPassword
        case .refreshToken:
            return kSecClassGenericPassword
        }
    }
}
