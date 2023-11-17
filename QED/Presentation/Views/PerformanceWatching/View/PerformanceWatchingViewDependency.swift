// Created by byo.

import Foundation

final class PerformanceWatchingViewDependency: ViewDependency {
    let performanceSettingManager: PerformanceSettingManager
    let isAllFormationVisible: Bool

    init(performanceSettingManager: PerformanceSettingManager, isAllFormationVisible: Bool) {
        self.performanceSettingManager = performanceSettingManager
        self.isAllFormationVisible = isAllFormationVisible
    }
}
