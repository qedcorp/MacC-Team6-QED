//
//  PerformanceWatchingListViewModel.swift
//  QED
//
//  Created by chaekie on 10/30/23.
//

import Foundation
import Combine

class PerformanceWatchingListViewModel: ObservableObject {
    @Published var performance: PerformanceModel
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(performanceSettingManager: PerformanceSettingManager, performanceUseCase: PerformanceUseCase) {
        self.performance = .build(entity: performanceSettingManager.performance)
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase
        subscribePerformanceSettingManager()
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager.changingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] in
                performance = $0
            }
            .store(in: &cancellables)
    }

    func removeFormation(index: Int) {
        performanceSettingManager.removeFormation(index: index)
    }
}
