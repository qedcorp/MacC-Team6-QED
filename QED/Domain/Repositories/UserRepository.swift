// Created by byo.

import Foundation

protocol UserRepository {
    func createUser(_ user: User) async throws -> User
    func readUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
}
