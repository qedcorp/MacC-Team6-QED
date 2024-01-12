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
        guard let nickname = user.nickname else {
            throw DescribableError(description: "Cannot update me")
        }
        try KeyChainManager.shared.create(account: .name, data: nickname)
        return user
    }

    func increaseLaunchingCount() -> Int {
        userStore.increaseLaunchingCount()
        guard let user = userStore.myUser else { return 0 }
        return user.launchingCount
    }

    func resetLaunchingCount() {
        userStore.resetLaunchingCount()
    }

}
