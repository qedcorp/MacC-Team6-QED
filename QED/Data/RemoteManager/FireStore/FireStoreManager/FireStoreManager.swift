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
    static var fireStoreKey: String {
        do {
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            dateFormatter.locale = Locale(identifier:"ko_KR")
            let myId = try KeyChainManager.shared.read(account: .id)
            let myFireStoreKey = dateFormatter.string(from: Date()) + myId
            
            return myFireStoreKey
        }
        catch {
            print("No KeyChain Id")
            return ""
        }
    }

    func create<T>(
        _ data: T,
        createType: CreateType
    ) async throws -> Result<T, Error>
    where T: Decodable, T: Encodable {

        guard var entityConvertable = data as? FireStoreEntityConvertable else {
            return .failure(FireStoreError.castingFailure("parameter Data can't casting FireStoreEntityConvertable"))
        }

        let fireStoreData = entityConvertable.fireStoreEntity
        var dataDic: [String: Any] = [:]
        
        for child in Mirror(reflecting: fireStoreData).children {
            guard let label = child.label else { continue }
            if label != "ID" && label != "collectionName" {
                dataDic[label] = child.value
            }
        }

        do {
            switch createType {
            case .noneKey:
                fireStroeDB
                    .collection(fireStoreData.collectionName)
                    .addDocument(data: dataDic)
                
            case .hasKey:
                let document = fireStroeDB
                    .collection(fireStoreData.collectionName)
                    .document()
                
                dataDic["ID"] = document.documentID
                try await document.setData(dataDic)
                entityConvertable.fireStoreID = document.documentID
            }
            
            guard let result = entityConvertable as? T else {
                return .failure(FireStoreError.fetchFailure)
            }
            
            return .success(result)
        }
        catch {
            print("Create Error")
            return .failure(FireStoreError.cantReadCollection)
        }
    }

    func read<T, K, U>(
        at endPoint: K = "",
        mockData: T,
        pk key: U
    ) async throws -> Result<T, Error>
    where T: Decodable, T: Encodable {
        guard let dataDTO = mockData as? FireStoreEntityConvertable,
              let key = key as? String else {
            return .failure(FireStoreError.castingFailure("parameter mockData can't casting FireStoreEntityConvertable"))
        }

        let collectionName = dataDTO.fireStoreEntity.collectionName

        guard let result = try? await fireStroeDB.collection(collectionName).document(key).getDocument().data() else {
            return .failure(FireStoreError.didntFindDoucument)
        }

        let dataResult = dataDTO.fireStoreEntity.fetchValue(id: key, data: result).entity
        guard let result = dataResult as? T else {
            return .failure(
                FireStoreError.fetchFailure
            )
        }
        
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

        try await fireStroeDB
            .collection(fireStoreData.collectionName)
            .document(dataDTO.fireStoreEntity.ID)
            .setData(dataDic, merge: true)

        
        return .success(data)
    }

    func delete<T, U>(at endPoint: T, pk key: U) async throws -> Result<Bool, Error> {
        guard let collectionName = endPoint as? String,
              let pk = key as? String else { return .failure(FireStoreError.keyTypeError) }
        try await fireStroeDB.collection(collectionName).document(pk).delete()
        return .success(true)
    }

}
