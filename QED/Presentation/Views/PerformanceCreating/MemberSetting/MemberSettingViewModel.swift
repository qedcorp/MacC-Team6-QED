// Created by byo.

import Combine
import Foundation

@MainActor
class MemberSettingViewModel: ObservableObject {
    private(set) var performanceSettingManager: PerformanceSettingManager?
    private(set) var performanceUseCase: PerformanceUseCase?
    private var hapticManager: HapticManager?
    @Published private(set) var performance: PerformanceModel?
    @Published private(set) var selectedMemberInfoIndex: Int?
    @Published private(set) var editingMemberInfoIndex: Int?
    private var cancellables: Set<AnyCancellable> = []

    func setupWithDependency(_ dependency: MemberSettingViewDependency) {
        performance = .build(entity: dependency.performanceSettingManager.performance)
        performanceSettingManager = dependency.performanceSettingManager
        performanceUseCase = dependency.performanceUseCase
        hapticManager = dependency.hapticManager
        subscribePerformanceSettingManager()
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager?.changingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] in
                performance = $0
            }
            .store(in: &cancellables)
    }

    var musicTitle: String {
        performance?.music.title ?? ""
    }

    var headcount: Int {
        performance?.headcount ?? 0
    }

    var memberInfos: [MemberInfoModel] {
        performance?.memberInfos ?? []
    }

    var selectedMemberInfo: MemberInfoModel? {
        guard let index = selectedMemberInfoIndex else {
            return nil
        }
        return performance?.memberInfos[safe: index]
    }

    var editingMemberInfo: MemberInfoModel? {
        guard let index = editingMemberInfoIndex else {
            return nil
        }
        return performance?.memberInfos[safe: index]
    }

    var formations: [FormationModel] {
        performance?.formations ?? []
    }

    var isEnabledToSave: Bool {
        performance?.formations.allSatisfy { !$0.colors.contains(nil) } == true
    }

    var nextPath: PresentType? {
        guard let performance = performance?.entity,
              isEnabledToSave else {
            return nil
        }
        if performance.isCompleted {
            let depepndency = PerformanceWatchingViewDependency(
                isAllFormationVisible: false,
                performanceSettingManager: performanceSettingManager
            )
            return .performanceWatching(depepndency)
        } else {
            let dependency = FormationSettingViewDependency(performance: performance)
            return .formationSetting(dependency)
        }
    }

    func selectMember(index: Int) {
        hapticManager?.hapticImpact(style: .light)
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
        performanceSettingManager?.updateMembers(colors: colors, formationIndex: formationIndex)
    }

    func updateEditingMemberInfo(_ info: MemberInfoModel) {
        guard let index = editingMemberInfoIndex else {
            return
        }
        performanceSettingManager?.updateMemberInfo(name: info.name, color: info.color, memberInfoIndex: index)
        hapticManager?.hapticImpact(style: .medium)
        animate {
            editingMemberInfoIndex = nil
        }
    }
}
