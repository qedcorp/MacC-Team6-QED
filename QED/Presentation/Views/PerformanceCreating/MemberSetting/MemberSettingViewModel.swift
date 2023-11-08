// Created by byo.

import Combine
import Foundation

@MainActor
class MemberSettingViewModel: ObservableObject {
    @Published private(set) var performance: PerformanceModel
    @Published private(set) var selectedMemberInfoIndex: Int?
    @Published private(set) var editingMemberInfoIndex: Int?
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(performanceSettingManager: PerformanceSettingManager, performanceUseCase: PerformanceUseCase) {
        self.performance = .build(entity: performanceSettingManager.performance)
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase
        subscribePerformanceSettingManager()
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager.changingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] in
                performance = $0
            }
            .store(in: &cancellables)
    }

    var musicTitle: String {
        performance.music.title
    }

    var headcount: Int {
        performance.headcount
    }

    var memberInfos: [MemberInfoModel] {
        performance.memberInfos
    }

    var selectedMemberInfo: MemberInfoModel? {
        guard let index = selectedMemberInfoIndex else {
            return nil
        }
        return performance.memberInfos[safe: index]
    }

    var editingMemberInfo: MemberInfoModel? {
        guard let index = editingMemberInfoIndex else {
            return nil
        }
        return performance.memberInfos[safe: index]
    }

    var formations: [FormationModel] {
        performance.formations
    }

    var isEnabledToSave: Bool {
        performance.formations.allSatisfy { !$0.colors.contains(nil) }
    }

    func selectMember(index: Int) {
        animate {
            if editingMemberInfoIndex == index {
                editingMemberInfoIndex = nil
            } else if selectedMemberInfoIndex == index {
                editingMemberInfoIndex = index
            } else {
                selectedMemberInfoIndex = index
                editingMemberInfoIndex = nil
            }
        }
    }

    func updateMembers(colors: [String?], formationIndex: Int) {
        performanceSettingManager.updateMembers(colors: colors, formationIndex: formationIndex)
    }

    func updateEditingMemberInfo(_ info: MemberInfoModel) {
        guard let index = editingMemberInfoIndex else {
            return
        }
        performanceSettingManager.updateMemberInfo(name: info.name, color: info.color, memberInfoIndex: index)
        animate {
            editingMemberInfoIndex = nil
        }
    }
}
