//
//  KeyChainAccount.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

enum KeyChainAccount: CaseIterable {
    case id
    case name
    case email
    case provider
    case signUpdate
    case refreshToken

    // 더 필요한 Account 추가

    var description: String {
        return String(describing: self)
    }

    var keyChainClass: CFString {
        kSecClassGenericPassword
    }
}
