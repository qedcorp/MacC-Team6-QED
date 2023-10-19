//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import SwiftUI

import Combine

class PerformanceSettingViewModel: ObservableObject {

    let bag = Set<AnyCancellable>()

    var headcount: Int? { Int(inputHeadcount) }
    @Published var inputTitle: String = ""
    @Published var inputHeadcount: String = "2"

    @Published var searchText: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false
    @Published var selectedMusic: Music?

    let usecase: MockUpSearchMusicUseCase = MockUpSearchMusicUseCase(
        searchMusicRepository: SearchMusicRepositoryImplement()
    )

    func search() {
        Task {
            isSearchingMusic = true
            searchedMusics = try await usecase.searchMusics(keyword: searchText)
            isSearchingMusic = false
        }
    }

    func decrementHeadcount() {
        if Int(inputHeadcount)! > 2 {
            let currentNumber = Int(inputHeadcount)!
            inputHeadcount = "\(currentNumber - 1)"
        }
    }

    func incrementHeadcount() {
        if Int(inputHeadcount)! < 13 {
            let currentNumber = Int(inputHeadcount)!
            inputHeadcount = "\(currentNumber + 1)"
        }
    }
}
