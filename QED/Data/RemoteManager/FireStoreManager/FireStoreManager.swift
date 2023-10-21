//
//  FireStoreManager.swift
//  QED
//
//  Created by changgyo seo on 10/20/23.
//

import Foundation

import FirebaseFirestore

final class FireStoreManager: RemoteManager {

    private var fireStroeDB: Firestore = Firestore.firestore()

    func create<T>(
        _ data: T
    ) async throws -> Result<T, Error>
    where T: Decodable, T: Encodable {
        guard let fireStoreData = data as? FireStoreEntity else {
            return .failure(FireStoreError.disableFireStoreType)
        }
        var dataDic: [String: Any] = [:]

        for child in Mirror(reflecting: fireStoreData).children {
            guard let label = child.label else { continue }
            if label != "ID" && label != "collectionName" {
                dataDic[label] = child.value
            }
        }

        fireStroeDB.collection(fireStoreData.collectionName).addDocument(data: dataDic)

        return .success(data)
    }

    func read<T, K, U>(
        at endPoint: K = "",
        mockData: T,
        pk key: U
    ) async throws -> Result<T, Error>
    where T: Decodable, T: Encodable {
        guard let returnValue = mockData as? FireStoreEntity,
              let key = key as? String else {
            return .failure(FireStoreError.keyTypeError)
        }

        let collectionName = returnValue.collectionName

        guard let result = try? await fireStroeDB.collection(collectionName).document(key).getDocument().data() else {
            return .failure(FireStoreError.didntFindDoucument)
        }

        returnValue.fetchValue(id: key, data: result)
        guard let result = returnValue as? T else { return . failure(FireStoreError.keyTypeError)}

        return .success(result)
    }

    func update<T>(_ data: T) async throws -> Result<T, Error> where T: Decodable, T: Encodable {
        .failure(FireStoreError.cantReadCollection)
    }

    func delete<T, U>(pk key: U) async throws -> Result<T, Error> where T: Decodable, T: Encodable {
        .failure(FireStoreError.cantReadCollection)
    }
}

fileprivate extension FireStoreManager {
    enum FireStoreError: Error {
        case didntFindDoucument
        case keyTypeError
        case cantReadCollection
        case disableFireStoreType
    }
}
