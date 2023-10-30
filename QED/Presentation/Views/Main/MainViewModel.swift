//
//  MainViewModel.swift
//  QED
//
//  Created by chaekie on 10/22/23.
//

import Foundation

@MainActor
class MainViewModel: ObservableObject {
    @Published var myRecentPerformances: [Performance] = []
    @Published var nickname: String = ""
    let performancesUseCase: PerformanceUseCase

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
