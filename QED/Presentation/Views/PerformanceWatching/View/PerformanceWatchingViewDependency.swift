// Created by byo.

import Foundation

final class PerformanceWatchingViewDependency: ViewDependency {
    let isAllFormationVisible: Bool
    let isCreatedNewPerformance: Bool
    let toastContainerViewModel: ToastContainerViewModel
    let performanceSettingManager: PerformanceSettingManager?

    init(
        isAllFormationVisible: Bool,
        isCreatedNewPerformance: Bool = false,
        toastContainerViewModel: ToastContainerViewModel = .shared,
        performanceSettingManager: PerformanceSettingManager?
    ) {
        self.isAllFormationVisible = isAllFormationVisible
        self.isCreatedNewPerformance = isCreatedNewPerformance
        self.toastContainerViewModel = toastContainerViewModel
        self.performanceSettingManager = performanceSettingManager
    }
}
