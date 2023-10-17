// Created by byo.

import Foundation

class MockUserRepository: UserRepository {
    let userStore: UserStore
    
    init(userStore: UserStore) {
        self.userStore = userStore
    }
    
    func createUser(_ user: User) async throws -> User {
        userStore.myUser = user
        return user
    }
    
    func readUser(email: String) async throws -> User {
        User(email: email)
    }
    
    func updateUser(_ user: User) async throws -> User {
        user
    }
}
