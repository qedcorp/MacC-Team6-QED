//
//  AuthRepository+.swift
//  QED
//
//  Created by changgyo seo on 10/19/23.
//

import FirebaseAuth
import FirebaseCore

extension AuthRepository {
    func registerKeyChain(authDataResult: AuthDataResult) throws {
        try KeyChainManager.shared.create(account: .id, data: authDataResult.user.uid)
        try KeyChainManager.shared.create(account: .name, data: authDataResult.user.displayName ?? "anonymous")
        try KeyChainManager.shared.create(account: .email, data: authDataResult.user.email ?? "no-mail")
        try KeyChainManager.shared.create(account: .refreshToken, data: authDataResult.user.refreshToken ?? "empty")
    }
}
