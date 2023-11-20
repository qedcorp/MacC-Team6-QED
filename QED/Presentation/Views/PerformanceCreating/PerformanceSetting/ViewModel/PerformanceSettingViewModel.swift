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
    @Published var performance: Performance? = Performance(id: "",
                                                           author: User(),
                                                           music: Music(id: "", title: "", artistName: ""),
                                                           headcount: 2)

    init(performanceUseCase: PerformanceUseCase) {
        self.performanceUseCase = performanceUseCase
    }
    @FocusState var isFocused: Bool
    @Published var isExpanded1: Bool = true
    @Published var isExpanded2: Bool = false
    @Published var isExpanded3: Bool = false
    @Published var scrollToID: Int?
    @State private var focusedIndex: Int?

    @Published var performanceTitle: String = ""
    @Published var musicSearch: String = ""
    @Published var allMusics: [Music] = []
    @Published var searchedMusics: [Music] = []
    @Published var isSearchingMusic: Bool = false
    @Published var selectedMusic: Music?
    var isAllSet: Bool {
        selectedMusic != nil && performanceTitle != "" && headcount != 1
    }
    @Published var headcount: Int = 1 {
        didSet(newValue) {
            updateHeadcount(newCount: newValue)
        }
    }
    @Published var range: ClosedRange<Int> = 1...13

    @Published var inputMemberInfo: [String] = []
    @Published var sliderCustomColor: Color = .blueLight3.opacity(0.3)
//    @Published var isShowingNextView: Bool = false
    @Published var alertMessage: [Message?] = []

    let musicUseCase: MusicUseCase = DefaultMusicUseCase(
        musicRepository: DefaultMusicRepository()
    )

    var albumCover: URL? {
        performance?.music.albumCoverURL
    }

    var musicTitle: String {
        selectedMusic?.title ?? ""
    }

    var artist: String {
        selectedMusic?.artistName ?? ""
    }

    func search() {
        Task {
            isSearchingMusic = true
            searchedMusics = try await musicUseCase.searchMusics(keyword: musicSearch)
            isSearchingMusic = false
        }
    }

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

    func getTaskForCreatePerformance() -> Task<Performance?, Never> {
        Task {
            await createPerformance()
        }
    }

    private func createPerformance() async -> Performance? {
        let memberInfo = zip(inputMemberInfo, MemberInfoColorset.getAllColors())
            .map { Member.Info(name: $0.isEmpty ? nil : $0, color: $1) }
        guard let id = try? KeyChainManager.shared.read(account: .id),
              let email = try? KeyChainManager.shared.read(account: .email),
              let nickname = try? KeyChainManager.shared.read(account: .name) else { return nil }
        let tempPerformance = Performance(
            id: "",
            author: User(id: id, email: email, nickname: nickname),
            music: selectedMusic ?? Music(id: "", title: "", artistName: ""),
            headcount: headcount,
            title: performanceTitle,
            memberInfos: memberInfo
        )
        return try? await performanceUseCase.createPerformance(performance: tempPerformance)
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
            scrollToID = 1
        }
    }

    func toggleDisclosureGroup3() {
        withAnimation {
            isExpanded3 = true
            isExpanded1 = false
            isExpanded2 = false
            scrollToID = 1
        }
    }

    func delete() {
        performanceTitle = ""
        selectedMusic = nil
        headcount = 1
        inputMemberInfo = ["", ""]
        isExpanded1 = true
        isExpanded2 = false
        isExpanded3 = false
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
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func isKeyboardVisible() -> Bool {
        return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0 > 0
    }

    func disclosureGroupLabelOpend() -> some View {
        modifier(DisclosureGroupLabelOpend())
    }
}
