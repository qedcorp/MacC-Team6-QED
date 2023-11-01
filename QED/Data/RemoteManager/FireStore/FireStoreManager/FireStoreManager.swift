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
        // 입력받은 entity data를 firestore에 맞는 DTO로 변경하는 작업
        guard let dataDTO = data as? FireStoreEntityConvertable else {
            return .failure(FireStoreError.castingFailure("parameter Data can't casting FireStoreEntityConvertable"))
        }
        let fireStoreData = dataDTO.fireStoreEntity
        var dataDic: [String: Any] = [:]
        
        // DTO를 [String: Any]로 타입을 변경하는 부분
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
                try await fireStroeDB
                    .collection(fireStoreData.collectionName)
                    .document(FireStoreManager.fireStoreKey)
                    .setData(dataDic)
            }
            
            return .success(data)
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
        // 주어진 entity를 firestore DTO로 뱉을 수 있도록 FireStoreEntituConvertable로 변경하는 작업
        guard let dataDTO = mockData as? FireStoreEntityConvertable,
              let key = key as? String else {
            return .failure(FireStoreError.castingFailure("parameter mockData can't casting FireStoreEntityConvertable"))
        }
        
        let collectionName = dataDTO.fireStoreEntity.collectionName
        // 실제 데이터를 불러오는 작업
        guard let result = try? await fireStroeDB.collection(collectionName).document(key).getDocument().data() else {
            return .failure(FireStoreError.didntFindDoucument)
        }
        // 이때 날라온 데이터는 [String: Any] 타입인데 이를 먼저 fetchvalue로 DTO형태로 바꾸고
        // 이에 다시 entity를 부르면서 실제 domain의 entity로 바꾸는 작업
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
            // 주어진 entity를 firestore DTO로 뱉을 수 있도록 FireStoreEntituConvertable로 변경하는 작업
            guard let collectionName = endPoint as? String,
                  let entity = mockData as? FireStoreEntityConvertable else {
                return .failure(FireStoreError.keyTypeError)
            }
            // readType으로 분기를 나눠 key의 유무와 key가 있다면 어떤 부분과 연동되야되는지 알려주는 부분
            var data: [QueryDocumentSnapshot] = []
            do {
                switch readType {
                case .all:
                    data = try await fireStroeDB.collection(collectionName).getDocuments().documents
                case .key(let field, let value):
                    guard let strValue = value as? String,
                          let strfield = field as? String else { return .failure(FireStoreError.keyTypeError) }
                    data = try await fireStroeDB.collection(collectionName)
                        .whereField(strfield, isEqualTo: strValue)
                        .getDocuments()
                        .documents
                }
                // 나온 data를 통해 각 data들을 DTO로 변경후 다시 domain entity로 변경
                var tempResults = data.map { snapshot in
                    guard let value = entity.fireStoreEntity.fetchValue(id: snapshot.documentID, data: snapshot.data()).entity as? T else {
                        return mockData
                    }
                    return value
                }
                
                return .success(tempResults)
            }
            catch {
                return .failure(FireStoreError.disableFireStoreType)
            }
            
            return .failure(FireStoreError.disableFireStoreType)
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
