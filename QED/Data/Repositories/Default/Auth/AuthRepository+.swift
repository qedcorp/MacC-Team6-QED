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
        let accounts: [KeyChainAccount] = KeyChainAccount.allCases
        let results: [String] = [
            authDataResult.user.uid,
            authDataResult.user.displayName ?? "anonymous",
            authDataResult.user.email ?? "no-email",
            authDataResult.user.providerID,
            authDataResult.user.metadata.creationDate?.description ?? "no-creationDate",
            authDataResult.user.refreshToken ?? "no-refreshToken"

        ]
        let zip = zip(accounts, results)
        for (account, data) in zip {
            try KeyChainManager.shared.create(account: account, data: data)
        }
    }

    func unregisterKeyChain(account: KeyChainAccount) throws {
        try KeyChainManager.shared.delete(account: account)
    }

    func unregisterKeyChain(accounts: [KeyChainAccount]) throws {
        for account in accounts {
            try KeyChainManager.shared.delete(account: account)
        }
    }
}
