// Created by byo.

import Foundation

final class FormationSettingViewDependency: ViewDependency {
    let performance: Performance
    let currentFormationIndex: Int
    let toastContainerViewModel: ToastContainerViewModel
    let hapticManager: HapticManager
    let performanceUseCase: PerformanceUseCase

    init(
        performance: Performance,
        currentFormationIndex: Int = -1,
        toastContainerViewModel: ToastContainerViewModel = .shared,
        hapticManager: HapticManager = .shared,
        performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    ) {
        self.performance = performance
        self.currentFormationIndex = currentFormationIndex
        self.toastContainerViewModel = toastContainerViewModel
        self.hapticManager = hapticManager
        self.performanceUseCase = performanceUseCase
    }
}
