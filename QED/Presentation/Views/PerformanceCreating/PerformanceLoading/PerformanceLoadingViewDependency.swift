// Created by byo.

import Foundation

final class PerformanceLoadingViewDependency: ViewDependency {
    let task: () -> Task<Performance?, Never>

    init(task: @escaping () -> Task<Performance?, Never>) {
        self.task = task
    }
}
