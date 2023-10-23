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
    @Published var inputHeadcount: Double = 2
    @Published var selectedMusic: Music?

    @Published var searchText: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false

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
        if inputHeadcount > 2.0 {
            inputHeadcount -= 1.0
        }
    }

    func incrementHeadcount() {
        if inputHeadcount < 13.0 {
            inputHeadcount += 1.0
        }
    }

    func generatePerformance() -> Performance {
        guard let music = selectedMusic else { return Performance(jsonString: "Error") }
        return Performance(author: User(id: "ADMIN", email: "ADMIN", nickname: "ADMIN"),
                    playable: music,
                    headcount: Int(inputHeadcount),
                    title: inputTitle,
                    formations: [],
                    transitions: [])
    }
}
