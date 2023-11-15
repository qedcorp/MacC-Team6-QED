// Created by byo.

import Foundation

struct MemberSettingTransferModel: Equatable, Hashable {
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    private let uuid = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
