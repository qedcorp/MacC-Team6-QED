// swiftlint:disable all
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
        // TODO: 여기서 entity를 DTO형태로 바꿀수 있어야해

        guard let dataDTO = data as? FireStoreEntityConvertable else {
            return .failure(FireStoreError.disableFireStoreType)
        }
        let fireStoreData = dataDTO.fireStoreEntity
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
        guard let dataDTO = mockData as? FireStoreEntityConvertable,
              let key = key as? String else {
            return .failure(FireStoreError.keyTypeError)
        }

        let collectionName = dataDTO.fireStoreEntity.collectionName

        guard let result = try? await fireStroeDB.collection(collectionName).document(key).getDocument().data() else {
            return .failure(FireStoreError.didntFindDoucument)
        }

        let dataResult = dataDTO.fireStoreEntity.fetchValue(id: key, data: result).entity
        guard let result = dataResult as? T else { return . failure(FireStoreError.keyTypeError)}

        return .success(result)
    }

    func reads<T, K, KeyType>(
        at endPoint: K,
        readType: ReadType,
        mockData: T,
        valueType: KeyType.Type) async throws -> Result<[T], Error> where T: Decodable, T: Encodable {

        guard let collectionName = endPoint as? String,
              let entity = mockData as? FireStoreEntityConvertable else {
            return .failure(FireStoreError.keyTypeError)
        }

        var tempResults: [T] = []
        do {
            switch readType {
            case .all:
                let data = try await fireStroeDB.collection(collectionName).getDocuments().documents
                tempResults = data.map { snapshot in
                    guard let value = entity.fireStoreEntity.fetchValue(id: snapshot.documentID, data: snapshot.data()).entity as? T else {
                        return mockData
                    }
                    return value
                }
            case .key(let field, let value):
                guard let strValue = value as? String,
                      let strfield = field as? String else { return .failure(FireStoreError.keyTypeError) }
                let data = try await fireStroeDB.collection(collectionName)
                    .whereField(strfield, isEqualTo: strValue)
                    .getDocuments()
                    .documents
                

                tempResults = data.map { snapshot in
                    print(snapshot.data())
                    guard let value = entity.fireStoreEntity.fetchValue(id: snapshot.documentID, data: snapshot.data()).entity as? T else {
                        return mockData
                    }
                    return value
                }
            }
        } catch {
            return .failure(FireStoreError.disableFireStoreType)
        }

        return .success(tempResults)
    }

    func update<T>(_ data: T) async throws -> Result<T, Error> where T: Decodable, T: Encodable {

        guard let dataDTO = data as? FireStoreEntityConvertable else {
            return .failure(FireStoreError.disableFireStoreType)
        }
        let fireStoreData = dataDTO.fireStoreEntity
        var dataDic: [String: Any] = [:]

        for child in Mirror(reflecting: fireStoreData).children {
            guard let label = child.label else { continue }
            if label != "ID" && label != "collectionName" {
                dataDic[label] = child.value
            }
        }

        try await fireStroeDB.collection(fireStoreData.collectionName).document().setData(dataDic, merge: true)

        return .success(data)
    }

    func delete<T, U>(at endPoint: T, pk key: U) async throws -> Result<Bool, Error> {
        guard let collectionName = endPoint as? String,
              let pk = key as? String else { return .failure(FireStoreError.keyTypeError) }
        try await fireStroeDB.collection(collectionName).document(pk).delete()
        return .success(true)
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
