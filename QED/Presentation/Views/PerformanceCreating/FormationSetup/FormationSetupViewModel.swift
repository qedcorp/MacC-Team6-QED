// Created by byo.

import Combine
import Foundation

@MainActor
class FormationSetupViewModel: ObservableObject {
    @Published var performance: PerformanceModel
    @Published var isMemoFormPresented = false
    @Published var currentFormationIndex = -1
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(performanceSettingManager: PerformanceSettingManager, performanceUseCase: PerformanceUseCase) {
        self.performance = .build(entity: performanceSettingManager.performance)
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase

        performanceSettingManager.changedPublisher
            .sink { _ in
            } receiveValue: { [weak self] in
                self?.performance = $0
            }
            .store(in: &cancellables)
    }

    var musicTitle: String {
        performance.music.title
    }

    var headcount: Int {
        performance.headcount
    }

    var formations: [FormationModel] {
        performance.formations
    }

    var currentFormation: FormationModel? {
        performance.formations[safe: currentFormationIndex]
    }

    var currentFormationTag: String {
        String(describing: performance.formations[safe: currentFormationIndex]?.relativePositions)
    }

    var isEnabledToEdit: Bool {
        currentFormationIndex >= 0
    }

    var isEnabledToSave: Bool {
        !formations.isEmpty &&
        formations.allSatisfy { $0.relativePositions.count == headcount }
    }

    func updateCurrentMemo(_ memo: String) {
        performanceSettingManager.updateMemo(memo, formationIndex: currentFormationIndex)
        isMemoFormPresented = false
    }

    func updateMembers(positions: [CGPoint]) {
        performanceSettingManager.updateMembers(positions: positions, formationIndex: currentFormationIndex)
    }

    func addFormation() {
        let formation = Formation()
        performanceSettingManager.addFormation(formation, index: currentFormationIndex + 1)
        currentFormationIndex += 1
    }

    func duplicateFormation(index: Int) {
        guard let copiedFormation = performance.formations[safe: index] else {
            return
        }
        let pastedFormation = Formation(
            members: copiedFormation.members.map { Member(relativePosition: $0.relativePosition) },
            memo: copiedFormation.memo
        )
        performanceSettingManager.addFormation(pastedFormation, index: index + 1)
        currentFormationIndex = index + 1
    }

    func removeFormation(index: Int) {
        performanceSettingManager.removeFormation(index: index)
        currentFormationIndex = index == currentFormationIndex ? index - 1 : index
    }
}
