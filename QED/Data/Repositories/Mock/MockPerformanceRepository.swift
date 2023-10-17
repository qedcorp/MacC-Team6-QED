// Created by byo.

import Foundation

class MockPerformanceRepository: PerformanceRepository {
    private var performances: [Performance] = []

    func createPerformance(_ performance: Performance) async throws -> Performance {
        performances.append(performance)
        return performance
    }

    func readPerformance() async throws -> Performance {
        guard let performance = performances.last else {
            throw DescribableError(description: "Cannot find a performance.")
        }
        return performance
    }

    func readPerformances() async throws -> [Performance] {
        performances
    }

    func updatePerformance(_ performance: Performance) async throws -> Performance {
        performance
    }
}
