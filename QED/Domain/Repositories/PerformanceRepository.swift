// Created by byo.

import Foundation

protocol PerformanceRepository {
    func createPerformance(_ performance: Performance) async throws -> Performance
    func readPerformance() async throws -> Performance
    func readPerformances() async throws -> [Performance]
    func updatePerformance(_ performance: Performance) async throws -> Performance
}
