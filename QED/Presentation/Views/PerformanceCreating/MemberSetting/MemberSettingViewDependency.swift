// Created by byo.

import Foundation

final class MemberSettingViewDependency: ViewDependency {
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    let hapticManager: HapticManager

    init(
        performanceSettingManager: PerformanceSettingManager,
        performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self),
        hapticManager: HapticManager = .shared
    ) {
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase
        self.hapticManager = hapticManager
    }
}
