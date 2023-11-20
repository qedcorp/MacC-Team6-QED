// Created by byo.

import Foundation

final class PerformanceSettingViewDependency: ViewDependency {
    let performanceUseCase: PerformanceUseCase

    init(performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)) {
        self.performanceUseCase = performanceUseCase
    }
}
