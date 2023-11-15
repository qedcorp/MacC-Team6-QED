// Created by byo.

import Foundation

struct DefaultPerformanceUseCase: PerformanceUseCase {
    let performanceRepository: PerformanceRepository
    let userStore: UserStore

    func createPerformance(performance: Performance) async throws -> Performance {
        return try await performanceRepository.createPerformance(performance)
    }

    func getMyRecentPerformances() async throws -> [Performance] {
        try await performanceRepository.readMyPerformances()
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        try await performanceRepository.updatePerformance(performance)
    }

    func removePerformance(_ performanceID: String) async throws -> Bool {
        try await performanceRepository.removePerformance(performanceID)
    }
}
