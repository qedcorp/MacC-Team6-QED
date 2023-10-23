// Created by byo.

import Foundation

protocol UserUseCase {
    func signup(user: User) async throws -> User
    func login(user: User) async throws -> User
    func getMe() async throws -> User
    func getUser(id: String) async throws -> User
    func updateMe(user: User) async throws -> User
}
