// Created by byo.

import Foundation

protocol PerformanceUseCase {
    func createPerformance(playable: Playable, headcount: Int) async throws -> Performance
    func getMyRecentPerformances() async throws -> [Performance]
    func updatePerformance(_ performance: Performance) async throws -> Performance
}
