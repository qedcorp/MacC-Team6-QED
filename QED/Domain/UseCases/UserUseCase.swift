// Created by byo.

import Foundation

protocol UserUseCase {
    func getMe() async throws -> User
    func getUser(id: String) async throws -> User
    func updateMe(user: User) async throws -> User
    func increaseLaunchingCount() -> Int
    func resetLaunchingCount()
}
