// Created by byo.

import Foundation

final class FormationSettingViewDependency: ViewDependency {
    let performance: Performance
    let currentFormationIndex: Int
    let isAutoUpdateDisabled: Bool
    let toastContainerViewModel: ToastContainerViewModel
    let hapticManager: HapticManager
    let performanceUseCase: PerformanceUseCase

    init(
        performance: Performance,
        currentFormationIndex: Int = -1,
        isAutoUpdateDisabled: Bool = false,
        toastContainerViewModel: ToastContainerViewModel = .shared,
        hapticManager: HapticManager = .shared,
        performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    ) {
        self.performance = performance
        self.currentFormationIndex = currentFormationIndex
        self.isAutoUpdateDisabled = isAutoUpdateDisabled
        self.toastContainerViewModel = toastContainerViewModel
        self.hapticManager = hapticManager
        self.performanceUseCase = performanceUseCase
    }
}
