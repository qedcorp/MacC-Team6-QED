//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import SwiftUI

@MainActor
class PerformanceSettingViewModel: ObservableObject {
    let performancesUseCase: PerformanceUseCase

    init(performancesUseCase: PerformanceUseCase) {
        self.performancesUseCase = performancesUseCase
    }

    var headcount: Int? { Int(inputHeadcount) }
    @Published var inputTitle: String = ""

    @Published var inputHeadcount: Double = 0
    @Published var range: ClosedRange<Double> = 0...13
    @State private var inputHeadcountChanged = false

    @Published var selectedMusic: Music?
    @Published var searchText: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false

    let musicUseCase: MockUpSearchMusicUseCase = MockUpSearchMusicUseCase(
        searchMusicRepository: SearchMusicRepositoryImplement()
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

    func createPerformance() -> Performance {
        // 이게 왜 자꾸 도는지... 
        print("jjj")
        guard let selectedMusic = selectedMusic else {
            return Performance(jsonString: "Error")
        }
        return Performance(id: "1212312313",
                           author: User(id: "ADMIN", email: "ADMIN", nickname: "ADMIN"),
                           playable: selectedMusic,
                           headcount: Int(inputHeadcount),
                           title: inputTitle,
                           formations: [],
                           transitions: [])
    }
}
