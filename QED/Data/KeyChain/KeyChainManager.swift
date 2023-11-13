//
//  KeyChainManager.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

import Security

final class KeyChainManager {

    static let shared = KeyChainManager()
    static let serviceName = "qed.QED.forma"

    private init() { }

    func create(account: KeyChainAccount, data: String) throws {
        let query = [
            kSecClass: account.keyChainClass,
            kSecAttrService: KeyChainManager.serviceName,
            kSecAttrAccount: account.description,
            kSecValueData: (data as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any
        ] as CFDictionary

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == noErr else {
            throw KeyChainError.unhandledError(status: status)
        }
    }

    func read(account: KeyChainAccount) throws -> String {
        let query = [
            kSecClass: account.keyChainClass,
            kSecAttrService: KeyChainManager.serviceName,
            kSecAttrAccount: account.description,
            kSecReturnData: true
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        guard status != errSecItemNotFound else {
            throw KeyChainError.itemNotFound
        }

        if status == errSecSuccess,
           let item = dataTypeRef as? Data,
           let data = String(data: item, encoding: String.Encoding.utf8) {
            return data
        } else {
            throw KeyChainError.unhandledError(status: status)
        }
    }

    func delete(account: KeyChainAccount) throws {
        let query = [
            kSecClass: account.keyChainClass,
            kSecAttrService: KeyChainManager.serviceName,
            kSecAttrAccount: account.description
        ] as CFDictionary

        let status = SecItemDelete(query)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeyChainError.unhandledError(status: status)
        }
    }
}
