//
//  PerformanceListReadingViewModel.swift
//  QED
//
//  Created by chaekie on 11/15/23.
//

import Foundation

class PerformanceListReadingViewModel: ObservableObject {
    @Published var performances: [PerformanceModel]
    let performanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)

    init(performances: [Performance]) {
        self.performances = performances
            .map { .build(entity: $0) }
    }

    func deletePerformance(index: Int, performanceID: String) {
        Task {
            let deleteResult = try await performanceUseCase.removePerformance(performanceID)
            if deleteResult {
                performances.remove(at: index)
            }
        }
    }

    func updatePerformanceTitle(performance: PerformanceModel, title: String) {
        Task {
            let performanceSettingManager = PerformanceSettingManager(performance: performance.entity, performanceUseCase: performanceUseCase)
            performanceSettingManager.updatePerformanceTitle(title: title)
        }
    }
}
