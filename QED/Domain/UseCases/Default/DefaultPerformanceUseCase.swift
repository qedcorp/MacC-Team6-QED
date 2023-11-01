// Created by byo.

import Foundation

struct DefaultPerformanceUseCase: PerformanceUseCase {
    let performanceRepository: PerformanceRepository
    let userStore: UserStore

    func createPerformance(playable: Playable, headcount: Int) async throws -> Performance {
        guard let author = userStore.myUser else {
            throw DescribableError(description: "Cannot find an author.")
        }
        // TODO: 이 부분도 Playable로 바꿀수 있도록 해야해!!!!
        guard let tempPlayalbe = playable as? Music else { return Performance.init(jsonString: "") }
        let performance = Performance(id: "qq", author: author, playable: tempPlayalbe, headcount: headcount)
        return try await performanceRepository.createPerformance(performance)
    }

    func getMyRecentPerformances() async throws -> [Performance] {
        try await performanceRepository.readMyPerformances()
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        try await performanceRepository.updatePerformance(performance)
    }
}
