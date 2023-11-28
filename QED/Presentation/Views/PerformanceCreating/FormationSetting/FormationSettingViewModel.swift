// Created by byo.

import Combine
import Foundation

@MainActor
class FormationSettingViewModel: ObservableObject {
    typealias Controller = ObjectCanvasViewController

    private(set) var presetContainerViewModel: PresetContainerViewModel?
    private(set) var performanceSettingManager: PerformanceSettingManager?
    private(set) var performanceUseCase: PerformanceUseCase?
    private var toastContainerViewModel: ToastContainerViewModel?
    private var hapticManager: HapticManager?

    private(set) lazy var canvasController = {
        let controller = Controller()
        controller.objectHistoryArchiver = objectHistoryArchiver
        return controller
    }()

    private(set) lazy var zoomableCanvasController = {
        let controller = Controller()
        controller.objectHistoryArchiver = objectHistoryArchiver
        return controller
    }()

    private(set) lazy var objectHistoryArchiver = {
        ObjectHistoryArchiver<Controller.History>()
    }()

    @Published private var performance: PerformanceModel?
    @Published private(set) var currentFormationIndex: Int?
    @Published private(set) var isMemoFormPresented = false
    @Published private(set) var hasMemoBeenInputted = false
    @Published private(set) var controllingFormationIndex: Int?

    @Published private(set) var isZoomed = false {
        didSet { assignControllerToArchiverByZoomed() }
    }

    private(set) var formationItemFrameMap: [Int: CGRect] = [:]
    private var tasksQueue: [() -> Void] = []
    private var cancellables: Set<AnyCancellable> = []

    var musicTitle: String {
        performance?.music.title ?? ""
    }

    var headcount: Int {
        performance?.headcount ?? 0
    }

    var formations: [FormationModel] {
        performance?.formations ?? []
    }

    var currentFormation: FormationModel? {
        guard let index = currentFormationIndex else {
            return nil
        }
        return performance?.formations[safe: index]
    }

    var currentFormationTag: String {
        String(describing: currentFormation?.relativePositions)
    }

    var isNavigationBarHidden: Bool {
        isMemoFormPresented || isZoomed
    }

    var isEnabledToEdit: Bool {
        guard let index = currentFormationIndex else {
            return false
        }
        return index >= 0
    }

    var isEnabledToSave: Bool {
        !formations.isEmpty &&
        formations.allSatisfy { $0.relativePositions.count == headcount }
    }

    func setupWithDependency(_ dependency: FormationSettingViewDependency) {
        performance = PerformanceModel.build(entity: dependency.performance)
        currentFormationIndex = dependency.currentFormationIndex
        hasMemoBeenInputted = !dependency.performance.formations
            .compactMap { $0.memo }
            .isEmpty
        presetContainerViewModel = PresetContainerViewModel(
            headcount: dependency.performance.headcount,
            canvasController: canvasController
        )
        performanceSettingManager = PerformanceSettingManager(
            performance: dependency.performance,
            isAutoUpdateDisabled: dependency.isAutoUpdateDisabled,
            performanceUseCase: dependency.performanceUseCase
        )
        performanceUseCase = dependency.performanceUseCase
        toastContainerViewModel = dependency.toastContainerViewModel
        hapticManager = dependency.hapticManager
        subscribePerformanceSettingManager()
        assignControllerToArchiverByZoomed()
        addFormationIfEmpty()
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager?.changingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] value in
                animate {
                    performance = value
                    controllingFormationIndex = nil
                    executePendingTasks()
                }
            }
            .store(in: &cancellables)
    }

    private func executePendingTasks() {
        while !tasksQueue.isEmpty {
            tasksQueue.popLast()?()
        }
    }

    private func addFormationIfEmpty() {
        guard formations.isEmpty else {
            return
        }
        addFormation()
    }

    func presentMemoForm() {
        hapticManager?.hapticImpact(style: .light)
        animate {
            isMemoFormPresented = true
        }
    }

    func updateCurrentMemo(_ memo: String) {
        guard let formationIndex = currentFormationIndex else {
            return
        }
        performanceSettingManager?.updateMemo(memo, formationIndex: formationIndex)
        hapticManager?.hapticNotification(type: .success)
        if !hasMemoBeenInputted {
            presetContainerViewModel?.toggleGrid(isPresented: true)
        }
        animate {
            isMemoFormPresented = false
        }
        tasksQueue.append { [unowned self] in
            hasMemoBeenInputted = true
        }
    }

    func updateMembers(positions: [CGPoint]) {
        guard let formationIndex = currentFormationIndex else {
            return
        }
        performanceSettingManager?.updateMembers(positions: positions, formationIndex: formationIndex)
    }

    func toggleZoom() {
        hapticManager?.hapticImpact(style: .light)
        animate {
            isZoomed.toggle()
        }
    }

    func addFormation() {
        let formation = Formation()
        let index = formations.count
        performanceSettingManager?.addFormation(formation, index: index)
        hapticManager?.hapticImpact(style: .medium)
        tasksQueue.append { [unowned self] in
            currentFormationIndex = index
        }
    }

    func selectFormation(index: Int) {
        hapticManager?.hapticImpact(style: .light)
        animate {
            if controllingFormationIndex == index {
                controllingFormationIndex = nil
            } else if currentFormationIndex == index {
                controllingFormationIndex = index
            } else {
                currentFormationIndex = index
                controllingFormationIndex = nil
            }
        }
    }

    func duplicateFormation(index: Int) {
        guard let copiedFormation = performance?.formations[safe: index] else {
            return
        }
        let pastedFormation = Formation(
            members: copiedFormation.members.map { Member(relativePosition: $0.relativePosition) },
            memo: copiedFormation.memo
        )
        performanceSettingManager?.addFormation(pastedFormation, index: index + 1)
        hapticManager?.hapticImpact(style: .medium)
        toastContainerViewModel?.presentMessage("레이어가 복제되었습니다")
        tasksQueue.append { [unowned self] in
            currentFormationIndex = index + 1
        }
    }

    func removeFormation(index: Int) {
        performanceSettingManager?.removeFormation(index: index)
        hapticManager?.hapticImpact(style: .medium)
        toastContainerViewModel?.presentMessage("레이어가 삭제되었습니다")
        tasksQueue.append { [unowned self] in
            guard let index = currentFormationIndex else {
                return
            }
            if formations.isEmpty {
                currentFormationIndex = -1
            } else if index <= index {
                currentFormationIndex = max(min(index - 1, formations.count - 1), 0)
            }
        }
    }

    func updateFormationItemFrameMap(_ frame: CGRect, index: Int) {
        formationItemFrameMap[index] = frame
    }

    private func assignControllerToArchiverByZoomed() {
        let controller = isZoomed ? zoomableCanvasController : canvasController
        objectHistoryArchiver.delegate = controller
        performanceSettingManager?.relativeCoordinateConverter = controller.relativeCoordinateConverter
    }
}
