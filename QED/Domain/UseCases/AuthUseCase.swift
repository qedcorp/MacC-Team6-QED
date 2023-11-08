//
//  AuthUseCase.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

protocol AuthUseCase {
    func login(authType: AuthProviderType) async throws -> Bool
    func logout(authType: AuthProviderType) async throws
    func withdraw() async throws
}
