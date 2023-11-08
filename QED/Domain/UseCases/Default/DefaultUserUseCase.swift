// Created by byo.

import Foundation

struct DefaultUserUseCase: UserUseCase {
    let userRepository: UserRepository
    let userStore: UserStore

    func getMe() async throws -> User {
        guard let user = userStore.myUser else {
            throw DescribableError(description: "Cannot find me.")
        }
        return user
    }

    func getUser(id: String) async throws -> User {
        try await userRepository.readUser(id: id)
    }

    func updateMe(user: User) async throws -> User {
        try KeyChainManager.shared.delete(account: .name)
        try KeyChainManager.shared.create(account: .name, data: user.nickname!)
        return user
    }
}
