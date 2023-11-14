//
//  MainViewModel.swift
//  QED
//
//  Created by chaekie on 10/22/23.
//
import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var myRecentPerformances: [PerformanceModel] = []

    @Published var isLoading: Bool = true
    let performanceUseCase: PerformanceUseCase

    init( performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }

    func fetchMyRecentPerformances() {
        Task {
            isLoading = true
            let performances = try await performanceUseCase.getMyRecentPerformances()
            myRecentPerformances = performances.map({ PerformanceModel.build(entity: $0) })
            isLoading = false
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
