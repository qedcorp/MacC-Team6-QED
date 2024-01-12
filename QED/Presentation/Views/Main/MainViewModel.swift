//
//  MainViewModel.swift
//  QED
//
//  Created by chaekie on 10/22/23.
//

import Combine
import Foundation

@MainActor
class MainViewModel: ObservableObject {
    let performanceUseCase: PerformanceUseCase
    let userUseCase: UserUseCase
    @Published private(set) var isFetchingPerformances = true
    @Published private(set) var myPerformances: [Performance] = []

    init(
        performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self),
        userUseCase: UserUseCase = DIContainer.shared.resolver.resolve(UserUseCase.self)
    ) {
        self.performanceUseCase = performanceUseCase
        self.userUseCase = userUseCase
    }

    var myRecentPerformances: [Performance] {
        myPerformances
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(8)
            .map { $0 }
    }

    func fetchMyRecentPerformances() {
        isFetchingPerformances = true
        Task {
            let performances = try await performanceUseCase.getMyRecentPerformances()
            DispatchQueue.main.async { [weak self] in
                animate {
                    self?.myPerformances = performances
                    self?.isFetchingPerformances = false
                }
            }
        }
    }
}
