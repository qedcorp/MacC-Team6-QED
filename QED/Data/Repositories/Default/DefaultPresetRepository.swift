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

    func updatePreset(_ preset: Preset) async throws -> Preset {
        do {
            let createResult = try await remoteManager.update(preset)
            switch createResult {
            case .success(let success):
                return success
            case .failure:
                print("update Error")
            }
        } catch {
            print("update Error")
        }
        return Preset(jsonString: "update Error")
    }

    func createPreset(_ preset: Preset) async throws -> Preset {
        do {
            let createResult = try await remoteManager.create(preset, createType: .noneKey)
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
        do {
            var readResult: Result<[Preset], Error>
            if headcount == nil {
                readResult = try await remoteManager.reads(at: "PRESET",
                                                           readType: .all,
                                                           mockData: Preset(jsonString: ""),
                                                           valueType: String.self)
            } else {
                readResult = try await remoteManager.reads(at: "PRESET",
                                                           readType: .key(field: "HEADCOUNT", value: "\(headcount!)"),
                                                           mockData: Preset(jsonString: ""),
                                                           valueType: String.self)
            }
            switch readResult {
            case .success(let success):
                return success
            default:
                print("error")
            }
        } catch {
        }
        return [Preset(jsonString: "3")]
    }
}
