//
//  AuthRepository.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

protocol AuthRepository {
    func logIn() async throws -> Bool
    func logOut() async throws
    func isValidAccessToken() async throws -> Bool
    func isValidRefreshToken() async throws -> Bool
    func getNewAccessToken() async throws -> Bool
}
