//
//  MainViewModel.swift
//  QED
//
//  Created by chaekie on 10/22/23.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    let performancesUseCase: PerformanceUseCase
    @Published var nickname: String = ""
    @Published var myRecentPerformances: [Performance] = []

    init(performancesUseCase: PerformanceUseCase) {
        self.performancesUseCase = performancesUseCase
    }

    func fetchMyRecentPerformances() {
        Task {
            myRecentPerformances = try await performancesUseCase.getMyRecentPerformances()
        }
    }

    func fetchUser() {
        do {
            nickname = try KeyChainManager.shared.read(account: .name)
        } catch {
            print(error)
        }
    }
}
