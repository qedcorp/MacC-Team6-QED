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

    @discardableResult
    func createPerformance() -> Performance {
        guard let selectedMusic = selectedMusic else {
            return Performance(jsonString: "Error")
        }
        let performance = Performance(id: "1212312313",
                                      author: User(id: "ADMIN", email: "ADMIN", nickname: "ADMIN"),
                                      music: selectedMusic,
                                      headcount: Int(inputHeadcount),
                                      title: inputTitle,
                                      formations: [],
                                      transitions: [])
        self.performance = performance
        return performance
    }

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
