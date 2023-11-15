// Created by byo.

import Foundation

protocol PerformanceRepository {
    func createPerformance(_ performance: Performance) async throws -> Performance
    func readPerformance() async throws -> Performance
    func readMyPerformances() async throws -> [Performance]
    func updatePerformance(_ performance: Performance) async throws -> Performance
    func removePerformance(_ performanceID: String) async throws -> Bool
}
