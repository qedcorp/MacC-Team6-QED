// Created by byo.

import Foundation

struct PerformanceLoadingData: Equatable, Hashable {
    let task: () -> Task<Performance?, Never>
    private let uuid = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
