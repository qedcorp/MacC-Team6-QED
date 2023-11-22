// Created by byo.

import Foundation

protocol PerformanceUseCase {
    func createPerformance(performance: Performance) async throws -> Performance
    func getMyRecentPerformances() async throws -> [Performance]
    func updatePerformance(_ performance: Performance) async throws
    func removePerformance(_ performanceID: String) async throws -> Bool
}
