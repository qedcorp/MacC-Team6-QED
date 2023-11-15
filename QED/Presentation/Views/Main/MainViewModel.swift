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
    @Published var nickname: String = ""
    @Published var myRecentPerformances: [Performance] = []
    let performanceUseCase: PerformanceUseCase

    init( performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }

    func fetchMyRecentPerformances() {

        DispatchQueue.global().async {
            Task {
                let performances = try await self.performanceUseCase.getMyRecentPerformances()
                DispatchQueue.main.async {
                    self.myRecentPerformances = performances
                }
            }
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
