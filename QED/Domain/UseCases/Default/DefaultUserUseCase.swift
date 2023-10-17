// Created by byo.

import Foundation

struct DefaultUserUseCase: UserUseCase {
    let userRepository: UserRepository
    let userStore: UserStore

    func signup(user: User) async throws -> User {
        try await userRepository.createUser(user)
    }

    func login(user: User) async throws -> User {
        let me = try await userRepository.readUser(email: user.email)
        userStore.me = me
        return me
    }

    func getMe() async throws -> User {
        guard let me = userStore.me else {
            fatalError("Cannot find me.")
        }
        return me
    }

    func getUser(email: String) async throws -> User {
        try await userRepository.readUser(email: email)
    }

    func updateMe(user: User) async throws -> User {
        guard user == userStore.me else {
            fatalError("It is not me.")
        }
        return try await userRepository.updateUser(user)
    }
}
