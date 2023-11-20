// Created by byo.

import Combine
import Foundation

@MainActor
class PerformanceLoadingViewModel: ObservableObject {
    private(set) var task: (() -> Task<Performance?, Never>)?
    private(set) var performance: Performance?
    @Published private(set) var isLoading: Bool = true

    func setupWithDependency(_ dependency: PerformanceLoadingViewDependency) {
        task = dependency.task
    }

    func executeTask() async {
        performance = await task?().value
    }

    func endLoading() {
        isLoading = false
    }
}
