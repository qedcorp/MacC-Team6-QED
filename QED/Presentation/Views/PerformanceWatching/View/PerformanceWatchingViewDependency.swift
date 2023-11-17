// Created by byo.

import Foundation

final class PerformanceWatchingViewDependency: ViewDependency {
    let isAllFormationVisible: Bool
    let performanceSettingManager: PerformanceSettingManager?

    init(isAllFormationVisible: Bool, performanceSettingManager: PerformanceSettingManager?) {
        self.isAllFormationVisible = isAllFormationVisible
        self.performanceSettingManager = performanceSettingManager
    }
}
