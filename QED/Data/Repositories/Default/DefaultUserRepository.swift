//
//  DefaultUserRepository.swift
//  QED
//
//  Created by changgyo seo on 10/20/23.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    
    func createUser(_ user: User) async throws -> User {
        User(id: "")
    }
    
    func readUser(id: String) async throws -> User {
        User(id: "")
    }
    
    func updateUser(_ user: User) async throws -> User {
        User(id: "")
    }
}
