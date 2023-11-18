// Created by byo.

import Foundation

final class PerformanceWatchingViewDependency: ViewDependency {
    let isAllFormationVisible: Bool
    let toastContainerViewModel: ToastContainerViewModel
    let performanceSettingManager: PerformanceSettingManager?

    init(
        isAllFormationVisible: Bool,
        toastContainerViewModel: ToastContainerViewModel = .shared,
        performanceSettingManager: PerformanceSettingManager?
    ) {
        self.isAllFormationVisible = isAllFormationVisible
        self.toastContainerViewModel = toastContainerViewModel
        self.performanceSettingManager = performanceSettingManager
    }
}
