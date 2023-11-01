//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import SwiftUI

 @MainActor
class PerformanceSettingViewModel: ObservableObject {
    let performanceUseCase: PerformanceUseCase
    private(set) var performance: Performance?
    private var yameNextView: FormationSettingView?

    init(performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }

    @Published var inputTitle: String = ""
    @Published var inputHeadcount: Double = 1
    @Published var range: ClosedRange<Double> = 1...13
    @State private var inputHeadcountChanged = false

    let musicUseCase: MusicUseCase = DefaultMusicUseCase(
        musicRepository: DefaultMusicRepository()
    )
    @Published var searchText: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false
    @Published var selectedMusic: Music? {
        didSet {
            createPerformance()
        }
    }
    @Published var canPressNextButton: Bool = false
    @Published var searchText: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false

    let musicUseCase: MusicUseCase = DefaultMusicUseCase(
        musicRepository: DefaultMusicRepository()
    )

    func search() {
        Task {
            isSearchingMusic = true
            searchedMusics = try await musicUseCase.searchMusics(keyword: searchText)
            isSearchingMusic = false
        }
    }

    func decrementHeadcount() {
        if inputHeadcount > range.lowerBound {
            inputHeadcount -= 1
            inputHeadcountChanged = true
        } else {
            inputHeadcount = range.lowerBound
        }
    }

    func incrementHeadcount() {
        if inputHeadcount < range.upperBound {
            inputHeadcount += 1
            inputHeadcountChanged = true
        } else {
            inputHeadcount = range.upperBound
        }
    }

    func createPerformance() {
        canPressNextButton = false
        Task {
            guard let selectedMusic = selectedMusic,
                  let performance = try? await performancesUseCase.createPerformance(music: selectedMusic, headcount: self.headcount) else { return }

            self.performance = performance
            canPressNextButton = true
        }
    }

    // TODO: 이거 알쥐??
    func buildYameNextView(performance: Performance) -> some View {
        if yameNextView == nil {
            yameNextView = FormationSettingView(
                performance: performance,
                performanceUseCase: performanceUseCase
            )
        }
        return yameNextView!
    }
}
