// Created by byo.

import Foundation

struct DefaultUserUseCase: UserUseCase {
    let userRepository: UserRepository
    let userStore: UserStore

    func signup(user: User) async throws -> User {
        try await userRepository.createUser(user)
    }

    func login(user: User) async throws -> User {
        let user = try await userRepository.readUser(email: user.email)
        userStore.myUser = user
        return user
    }

    func getMe() async throws -> User {
        guard let user = userStore.myUser else {
            throw DescribableError(description: "Cannot find me.")
        }
        return user
    }

    func getUser(email: String) async throws -> User {
        try await userRepository.readUser(email: email)
    }

    func updateMe(user: User) async throws -> User {
        guard user == userStore.myUser else {
            throw DescribableError(description: "It is not me.")
        }
        return try await userRepository.updateUser(user)
    }
}
