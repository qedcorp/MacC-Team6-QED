//
//  RemoteManager.swift
//  QED
//
//  Created by changgyo seo on 10/20/23.
//

import Foundation

protocol RemoteManager {
    func create<T: Codable>(_ data: T, createType: CreateType) async throws -> Result<T, Error>
    func read<T: Codable, K, U>(at endPoint: K,
                                mockData: T,
                                pk key: U) async throws -> Result<T, Error>
    func reads<T: Codable, K, KeyType>(at endPoint: K,
                                                   readType: ReadType,
                                                   mockData: T,
                                                   valueType: KeyType.Type) async throws -> Result<[T], Error>
    func update<T: Codable>(_ data: T) async throws -> Result<T, Error>
    func delete<T, U>(at endPoint: T,
                      pk key: U) async throws -> Result<Bool, Error>
}

enum CreateType {
    case noneKey
    case hasKey
}

enum ReadType {
    case all
    case key(field: Any, value: Any)
}
