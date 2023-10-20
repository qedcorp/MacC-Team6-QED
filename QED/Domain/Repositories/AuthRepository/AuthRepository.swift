//
//  AuthRepository.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

protocol AuthRepository {
    func login() async throws -> Bool
    func logout() async throws
}
