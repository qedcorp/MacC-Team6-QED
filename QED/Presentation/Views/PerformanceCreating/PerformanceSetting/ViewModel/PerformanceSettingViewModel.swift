//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import SwiftUI

@MainActor
class PerformanceSettingViewModel: ObservableObject {
    //    @Published var performance: PerformanceModel
    let performanceUseCase: PerformanceUseCase
    //    private(set) var yameNextView: FormationSettingView?
    @Published var performance: Performance?

    init(performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }
    @Published var isExpanded1: Bool = true
    @Published var isExpanded2: Bool = false
    @Published var isExpanded3: Bool = false

    @Published var performanceTitle: String = ""
    @Published var musicSearch: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false
    @Published var selectedMusic: Music?
    //    @Published var artist: String = ""

    @Published var headcount: Int = 2 {
        didSet(newValue) {
            updateHeadcount(newCount: newValue)
        }
    }
    @Published var range: ClosedRange<Int> = 2...13
    @Published var inputMemberInfo: [String] = []
    @Published var inputMemberDefault: String = ""
    @Published var isCreateButton: Bool = false {
        didSet {
            createPerformance()
        }
    }
    @Published var isShowingNextView: Bool = false
    // 빠져도 됌
    @Published var canPressNextButton: Bool = false

    let musicUseCase: MusicUseCase = DefaultMusicUseCase(
        musicRepository: DefaultMusicRepository()
    )

    var albumCover: URL? {
        performance?.music.albumCoverURL
    }

    var musicTitle: String {
        selectedMusic?.title ?? "_"
    }

    var artist: String {
        selectedMusic?.artistName ?? "_"
    }

    // music func

    func search() {
        Task {
            isSearchingMusic = true
            searchedMusics = try await musicUseCase.searchMusics(keyword: musicSearch)
            isSearchingMusic = false
        }
    }

    // headcount func

    func decrementHeadcount() {
        if headcount > range.lowerBound {
            updateHeadcount(newCount: headcount)
            headcount -= 1
            inputMemberInfo.removeLast()
        } else {
            headcount = range.lowerBound
        }
    }

    func incrementHeadcount() {
        if headcount < range.upperBound {
            updateHeadcount(newCount: headcount)
            headcount += 1
            inputMemberInfo.append("")
        } else {
            headcount = range.upperBound
        }
    }

    func updateHeadcount(newCount: Int) {
        if newCount > inputMemberInfo.count {
            for _ in inputMemberInfo.count..<newCount {
                inputMemberInfo.append("")
            }
        } else if newCount < inputMemberInfo.count {
            for _ in newCount..<inputMemberInfo.count {
                inputMemberInfo.removeLast()
            }
        }
    }

    func toggleDisclosureGroup1() {
        isExpanded1 = true
        isExpanded2 = false
        isExpanded3 = false
    }

    func toggleDisclosureGroup2() {
        isExpanded2 = true
        isExpanded1 = false
        isExpanded3 = false
    }

    func toggleDisclosureGroup3() {
        isExpanded3 = true
        isExpanded1 = false
        isExpanded2 = false

    }

    // TODO: 다음뷰로 넘어가면서 create되어야함
    func createPerformance() {
        isShowingNextView = false
        Task {
            do {
                if isCreateButton {
                    let performance = try await performanceUseCase.createPerformance(music: selectedMusic ?? Music(id: "_", title: "_", artistName: "_"), headcount: headcount)
                    self.performance = performance
                    isShowingNextView = true
                }
            } catch {
                print("error")
            }
        }
    }

    // TODO: 이거 알쥐??
    //    func buildYameNextView(performance: Performance) -> some View {
    //        if yameNextView == nil {
    //            yameNextView = FormationSettingView(
    //                performance: performance,
    //                performanceUseCase: performanceUseCase
    //            )
    //        }
    //        return yameNextView!
    //    }
}

struct DoubleToIntConverter1 {

    var inputHeadcount: Binding<Int>

    init(_ intValue: Binding<Int>) {
        self.inputHeadcount = intValue
    }

    var doubleValue: Binding<Double> {
        Binding<Double>(
            get: { Double(inputHeadcount.wrappedValue) },
            set: { newValue in
                inputHeadcount.wrappedValue = Int(newValue)
            }
        )
    }
}
