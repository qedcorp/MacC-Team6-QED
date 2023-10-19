// Created by byo.

import Foundation

struct DefaultPerformanceUseCase: PerformanceUseCase {
    let performanceRepository: PerformanceRepository
    let userStore: UserStore

    func createPerformance(playable: Playable, headcount: Int) async throws -> Performance {
        guard let author = userStore.myUser else {
            throw DescribableError(description: "Cannot find an author.")
        }
        let performance = Performance(author: author, playable: playable, headcount: headcount)
        return try await performanceRepository.createPerformance(performance)
    }

    func getMyRecentPerformances() async throws -> [Performance] {
        try await performanceRepository.readPerformances()
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        try await performanceRepository.updatePerformance(performance)
    }
}
