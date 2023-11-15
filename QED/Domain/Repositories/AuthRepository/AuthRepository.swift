//
//  AuthRepository.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation
import FirebaseAuth

protocol AuthRepository {
    func login() async throws -> Bool
    func logout() async throws
}

extension AuthRepository {
    func withdraw() async throws {
        if let user = Auth.auth().currentUser {
            user.delete { [self] error in
                if let error = error {
                    print("Error delete user: %@", error)
                } else {
                    print("Successful withdrawal")
                }
            }
            try unregisterKeyChain(accounts: KeyChainAccount.allCases)
        } else {
            print("Login information does not exist")
        }
    }
}
