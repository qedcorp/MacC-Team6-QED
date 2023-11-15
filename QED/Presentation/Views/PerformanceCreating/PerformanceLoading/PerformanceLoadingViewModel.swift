// Created by byo.

import Combine
import Foundation

@MainActor
class PerformanceLoadingViewModel: ObservableObject {
    var data: PerformanceLoadingData?
    @Published private(set) var isLoading: Bool
    private(set) var performance: Performance?

    init(isLoading: Bool = true) {
        self.isLoading = isLoading
    }

    func executeTask() async {
        let task = data?.task()
        performance = await task?.value
    }

    func endLoading() {
        isLoading = false
    }
}
