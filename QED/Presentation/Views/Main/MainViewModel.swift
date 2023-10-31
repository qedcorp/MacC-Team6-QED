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
    @Published var myRecentPerformances: [PerformanceModel] = []
    let performanceUseCase: PerformanceUseCase

    init( performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }

    func fetchMyRecentPerformances() {
        Task {
            let performances = try await performanceUseCase.getMyRecentPerformances()
            myRecentPerformances = performances.map({ PerformanceModel.build(entity: $0) })
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
