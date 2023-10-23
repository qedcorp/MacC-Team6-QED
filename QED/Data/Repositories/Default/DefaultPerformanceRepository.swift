//
//  DefaultPerformanceRepository.swift
//  QED
//
//  Created by changgyo seo on 10/22/23.
//

import Foundation

final class DefaultPerformanceRepository: PerformanceRepository {

    var remoteManager: RemoteManager

    init(remoteManager: RemoteManager) {
        self.remoteManager = remoteManager
    }

    func createPerformance(_ performance: Performance) async throws -> Performance {
        do {
            let createResult = try await remoteManager.create(performance)
            switch createResult {
            case .success(let success):
                return success
            case .failure:
                print("Create Error")
            }
        } catch {
            print("Create Error")
        }
        return Performance(jsonString: "Create Error")
    }

    func readPerformance() async throws -> Performance {
//        do {
//            let myID = try KeyChainManager.shared.read(account: .id)
//            let readResult = try await remoteManager.reads(at: "PERFORMANCE",
//                                                           readType: .key(field: "ID", value: myID),
//                                                           mockData: Performance(jsonString: ""),
//                                                           returnType: [Performance].self)
//            switch readResult {
//            case .success(let success):
//                return success
//            case .failure:
//                print("Create Error")
//            }
//        } catch {
//            print("Create Error")
//        }
        return Performance(jsonString: "Create Error")
    }

    func readPerformances() async throws -> [Performance] {
        return []
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        do {
            let myID = try KeyChainManager.shared.read(account: .id)
            let updateResult = try await remoteManager.update(performance)
            switch updateResult {
            case .success(let success):
                return success
            case .failure:
                print("Update Error")
            }
        } catch {
            print("Update Error")
        }
        return Performance(jsonString: "Update Error")
    }

}
