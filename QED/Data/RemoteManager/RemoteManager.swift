//
//  RemoteManager.swift
//  QED
//
//  Created by changgyo seo on 10/20/23.
//

import Foundation

protocol RemoteManager {
    func create<T: Codable>(_ data: T) async throws -> Result<T, Error>
    func read<T: Codable, K, U>(at endPoint: K, mockData: T, pk key: U) async throws -> Result<T, Error>
    func update<T: Codable>(_ data: T) async throws -> Result<T, Error>
    func delete<T: Codable, U>(pk key: U) async throws -> Result<T, Error>
}
