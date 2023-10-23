//
//  DefaultPresetRepository.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import Foundation
import FirebaseFirestore

final class DefaultPresetRepository: PresetRepository {

    var remoteManager: RemoteManager

    init(remoteManager: RemoteManager) {
        self.remoteManager = remoteManager
    }

    func createPreset(_ preset: Preset) async throws -> Preset {
        do {
            let createResult = try await remoteManager.create(preset)
            switch createResult {
            case .success(let success):
                return success
            case .failure:
                print("Create Error")
            }
        } catch {
            print("Create Error")
        }
        return Preset(jsonString: "Create Error")
    }

    func readPresets(headcount: Int?) async throws -> [Preset] {
//        do {
//            let db = Firestore.firestore()
//            if headcount == nil {
//                let readResult = try await db.collection("PRESET").getDocuments().documents
//            }
//            else {
//                let readResult = try await db.collection("PRESET").whereField("HEADCOUNT", isEqualTo: headcount!).getDocuments().documents
//                readResult.first?.data()
//            }
//            switch readResult {
//            case .success(let success):
//                return success
//            default:
//                print("1")
//            }
//        } catch {
//            print("2")
//        }
        return [Preset(jsonString: "3")]
    }
}
