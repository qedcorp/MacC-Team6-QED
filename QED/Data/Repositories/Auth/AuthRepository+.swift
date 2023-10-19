//
//  AuthRepository+.swift
//  QED
//
//  Created by changgyo seo on 10/19/23.
//

import FirebaseAuth
import FirebaseCore

extension AuthRepository {
    func registerKeyChain(with authDataResult: AuthDataResult) throws {
        try KeyChainManager.shared.create(account: .id, data: authDataResult.user.uid)
        try KeyChainManager.shared.create(account: .name, data: authDataResult.user.displayName ?? "anonymous")
        try KeyChainManager.shared.create(account: .email, data: authDataResult.user.email ?? "no-email")
        try KeyChainManager.shared.create(account: .refreshToken, data: authDataResult.user.refreshToken ?? "no-refreshToken")
    }

    func unregisterKeyChain(accounts: [KeyChainAccount]) throws {
        for account in accounts {
            try KeyChainManager.shared.delete(account: account)
        }
    }
}
