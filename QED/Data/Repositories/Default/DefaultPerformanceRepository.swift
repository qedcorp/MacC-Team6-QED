//  swiftlint:disable all
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
            let createResult = try await remoteManager.create(performance, createType: .hasKey)
            switch createResult {
            case .success(let success):
                return success
            case .failure(let error):
                throw error
            }
        } catch {
            print("Create Performance Error")
        }
        return Performance(jsonString: "Create Performance Error")
    }

    func readPerformance() async throws -> Performance {
        Performance(jsonString: "")
    }

    func readMyPerformances() async throws -> [Performance] {
        do {
            let myID = try KeyChainManager.shared.read(account: .id)
            let readResult = try await remoteManager.reads(at: "PERFORMANCE",
                                                           readType: .key(field: "ID", value: myID),
                                                           mockData: Performance(id: "", author: User(id: "failure"), music: Music(id: "failure", title: "failure", artistName: "failure"), headcount: 5),
                                                           valueType: String.self)
            switch readResult {
            case .success(let success):
                return success
            case .failure(let error):
                throw(error)
            }
        } catch {
            print("Read My Performances Error")
        }
        return [Performance(jsonString: "Read My Performances Error")]
    }

    func updatePerformance(_ performance: Performance) async throws {
        do {
            let updateResult = try await remoteManager.update(performance)
            switch updateResult {
            case .success:
                print("Successfully Update Performance")
            case .failure:
                throw DataError(message: "프로젝트 수정에 실패했습니다")
            }
        } catch {
            print("Update Performance Error")
        }
    }

    func removePerformance(_ performanceID: String) async throws -> Bool {
        do {
            let deleteResult = try await remoteManager.delete(at: "PERFORMANCE", pk: performanceID)
            switch deleteResult {
            case .success(let success):
                return success
            case .failure:
                throw DataError(message: "프로젝트 삭제에 실패했습니다")
            }
        } catch {
            print("Remove Performance Error")
        }
        return false
    }
    
    func searchPerformance(_ performanceID: String) async throws -> Performance {
        do {
            let createResult = try await remoteManager.read(at: "PERFORMANCE",
                                                            mockData: Performance(id: "", author: User(id: "failure"), music: Music(id: "failure", title: "failure", artistName: "failure"), headcount: 5),
                                                            pk: performanceID)
            switch createResult {
            case .success(let success):
                return success
            case .failure(let error):
                throw error
            }
        } catch {
            print("Create Performance Error")
        }
        return Performance(jsonString: "Create Performance Error")
    }
}
