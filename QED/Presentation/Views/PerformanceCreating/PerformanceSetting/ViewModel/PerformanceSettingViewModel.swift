//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import SwiftUI

// import Combine

@MainActor
class PerformanceSettingViewModel: ObservableObject {

    var headcount: Int? { Int(inputHeadcount) }
    @Published var inputTitle: String = ""
    @Published var inputHeadcount: Double = 0
    @Published var range: ClosedRange<Double> = 0...13

    @Published var selectedMusic: Music?
    @Published var searchText: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false

    @State private var inputHeadcountChanged = false

    let usecase: MockUpSearchMusicUseCase = MockUpSearchMusicUseCase(
        searchMusicRepository: MockSearchMusicRepository()
    )

    func search() {
        Task {
            isSearchingMusic = true
            searchedMusics = try await usecase.searchMusics(keyword: searchText)
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

    func generatePerformance() -> Performance {
        guard let music = selectedMusic else { return Performance(jsonString: "Error") }
        return Performance(id: "1212312313", author: User(id: "ADMIN", email: "ADMIN", nickname: "ADMIN"),
                           playable: music,
                           headcount: Int(inputHeadcount),
                           title: inputTitle,
                           formations: [],
                           transitions: [])
    }
}
