//
//  DefaultUserRepository.swift
//  QED
//
//  Created by changgyo seo on 10/20/23.
//

import Foundation

final class DefaultUserRepository: UserRepository {

    var remoteManager: RemoteManager

    init(remoteManager: RemoteManager) {
        self.remoteManager = remoteManager
    }

    func createUser(_ user: User) async throws -> User {
        do {
            let createResult = try await remoteManager.create(user, createType: .noneKey)
            switch createResult {
            case .success(let success):
                return success
            case .failure:
                print("Create Error")
            }
        } catch {
            print("Create Error")
        }
        return User(id: "Error")
    }

    func readUser(id: String) async throws -> User {
        do {
            let readResult = try await remoteManager.read(at: "", mockData: User(id: ""), pk: id)
            switch readResult {
            case .success(let success):
                return success
            case .failure:
                print("Read Error")
            }
        } catch {
            print("Read Error")
        }
        return User(id: "Read Error")
    }

    func updateUser(_ user: User) async throws -> User {
        do {
            let readResult = try await remoteManager.update(user)
            switch readResult {
            case .success(let success):
                return success
            case .failure:
                print("Update Error")
            }
        } catch {
            print("Update Error")
        }
        return User(id: "Update Error")
    }
}
