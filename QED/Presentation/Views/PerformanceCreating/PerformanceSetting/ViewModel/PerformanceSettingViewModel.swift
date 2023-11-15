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
    private(set) var yameNextView: FormationSettingView?
    @Published var performance: Performance? = Performance(id: "",
                                                           author: User(),
                                                           music: Music(id: "", title: "", artistName: ""),
                                                           headcount: 2)

    init(performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }
    @Published var isExpanded1: Bool = true
    @Published var isExpanded2: Bool = false
    @Published var isExpanded3: Bool = false
    @Published var scrollToID: Int?

    @Published var performanceTitle: String = ""
    @Published var musicSearch: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false
    @Published var selectedMusic: Music?

    @Published var headcount: Int = 2 {
        didSet(newValue) {
            updateHeadcount(newCount: newValue)
        }
    }
    @Published var range: ClosedRange<Int> = 2...13
    @Published var inputMemberInfo: [String] = []

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

    func generatePerformance() -> Performance {
        let memberInfo = zip(inputMemberInfo, MemberInfoColorset.getAllColors())
            .map { Member.Info(name: $0, color: $1) }
        guard let id = try? KeyChainManager.shared.read(account: .id),
              let email = try? KeyChainManager.shared.read(account: .email),
              let nickname = try? KeyChainManager.shared.read(account: .name) else { return mockPerformance1 }
        return Performance(id: "",
                           author: User(id: id, email: email, nickname: nickname), music: selectedMusic ?? Music(id: "", title: "", artistName: ""),
                           headcount: headcount, title: performanceTitle, memberInfos: memberInfo)
    }

    func toggleDisclosureGroup1() {
        withAnimation {
            isExpanded1 = true
            isExpanded2 = false
            isExpanded3 = false
            scrollToID = 1
        }
    }

    func toggleDisclosureGroup2() {
        withAnimation {
            isExpanded2 = true
            isExpanded1 = false
            isExpanded3 = false
            scrollToID = 2
        }
    }

    func toggleDisclosureGroup3() {
        withAnimation {
            isExpanded3 = true
            isExpanded1 = false
            isExpanded2 = false
            scrollToID = 3
        }
    }

    func allClear() {
        performanceTitle = ""
        selectedMusic = nil
        headcount = 2
        inputMemberInfo = ["", ""]
    }

    // TODO: 다음뷰로 넘어가면서 create되어야함

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

struct DisclosureGroupBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.monoNormal1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Gradient.strokeGlass2)
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 3)
            .tint(.clear)
    }

}

struct DisclosureGroupLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.blueLight3)
            .font(.title3)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 20)
    }
}

struct DisclosureGroupLabelOpend: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .padding(.vertical, 20)
    }
}

extension View {
    func disclosureGroupBackground() -> some View {
        modifier(DisclosureGroupBackground())
    }

    func disclosureGroupLabelStyle() -> some View {
        modifier(DisclosureGroupLabelStyle())
    }

    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil
        )
    }

    func disclosureGroupLabelOpend() -> some View {
        modifier(DisclosureGroupLabelOpend())
    }
}
