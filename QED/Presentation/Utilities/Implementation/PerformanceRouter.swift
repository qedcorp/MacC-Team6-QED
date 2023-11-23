// Created by byo.

import Foundation

struct PerformanceRouter {
    let performance: Performance

    func getBranchedPath() -> PresentType {
        if performance.isCompleted {
            let manager = PerformanceSettingManager(performance: performance)
            let depepndency = PerformanceWatchingViewDependency(
                isAllFormationVisible: false,
                performanceSettingManager: manager
            )
            return .performanceWatching(depepndency)
        } else {
            let dependency = FormationSettingViewDependency(performance: performance)
            return .formationSetting(dependency)
        }
    }
}
