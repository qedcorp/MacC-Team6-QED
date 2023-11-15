// Created by byo.

import Combine
import Foundation

@MainActor
class FormationSettingViewModel: ObservableObject {
    typealias Controller = ObjectCanvasViewController

    let canvasController: Controller
    let zoomableCanvasController: Controller
    let objectHistoryArchiver: ObjectHistoryArchiver<Controller.History>
    let presetContainerViewModel: PresetContainerViewModel
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    let memberSettingTransferModel: MemberSettingTransferModel
    private let toastContainerViewModel: ToastContainerViewModel
    private let hapticManager: HapticManager

    @Published private(set) var performance: PerformanceModel
    @Published private(set) var currentFormationIndex: Int
    @Published private(set) var isMemoFormPresented = false
    @Published private(set) var controllingFormationIndex: Int?
    @Published private(set) var hasMemoBeenInputted = false

    @Published private(set) var isZoomed = false {
        didSet { assignControllerToArchiverByZoomed() }
    }
    private(set) var formationItemFrameMap: [Int: CGRect] = [:]
    private var tasksQueue: [() -> Void] = []
    private var cancellables: Set<AnyCancellable> = []

    init(
        performance: Performance,
        currentFormationIndex: Int = -1,
        toastContainerViewModel: ToastContainerViewModel = .shared,
        hapticManager: HapticManager = .shared,
        performanceUseCase: PerformanceUseCase
    ) {
        let canvasController = Controller()
        let zoomableCanvasController = Controller()
        let objectHistoryArchiver = ObjectHistoryArchiver<Controller.History>()
        let performanceSettingManager = PerformanceSettingManager(
            performance: performance,
            performanceUseCase: performanceUseCase
        )

        canvasController.objectHistoryArchiver = objectHistoryArchiver
        zoomableCanvasController.objectHistoryArchiver = objectHistoryArchiver

        self.performance = .build(entity: performance)
        self.currentFormationIndex = currentFormationIndex
        self.canvasController = canvasController
        self.zoomableCanvasController = zoomableCanvasController
        self.objectHistoryArchiver = objectHistoryArchiver
        self.presetContainerViewModel = PresetContainerViewModel(
            headcount: performance.headcount,
            canvasController: canvasController
        )
        self.toastContainerViewModel = toastContainerViewModel
        self.hapticManager = hapticManager
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase
        self.memberSettingTransferModel = MemberSettingTransferModel(
            performanceSettingManager: performanceSettingManager,
            performanceUseCase: performanceUseCase
        )

        subscribePerformanceSettingManager()
        assignControllerToArchiverByZoomed()
        addFormationIfEmpty()
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager.changingPublisher
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

    func presentMemoForm() {
        hapticManager.hapticImpact(style: .light)
        animate {
            isMemoFormPresented = true
        }
    }

    func updateCurrentMemo(_ memo: String) {
        performanceSettingManager.updateMemo(memo, formationIndex: currentFormationIndex)
        hapticManager.hapticNotification(type: .success)
        if !hasMemoBeenInputted {
            presetContainerViewModel.toggleGrid(isPresented: true)
        }
        animate {
            isMemoFormPresented = false
        }
        tasksQueue.append { [unowned self] in
            hasMemoBeenInputted = true
        }
    }

    func updateMembers(positions: [CGPoint]) {
        performanceSettingManager.updateMembers(positions: positions, formationIndex: currentFormationIndex)
    }

    func toggleZoom() {
        hapticManager.hapticImpact(style: .light)
        animate {
            isZoomed.toggle()
        }
    }

    func addFormation() {
        let formation = Formation()
        let index = formations.count
        performanceSettingManager.addFormation(formation, index: index)
        hapticManager.hapticImpact(style: .medium)
        tasksQueue.append { [unowned self] in
            currentFormationIndex = index
        }
    }

    func selectFormation(index: Int) {
        hapticManager.hapticImpact(style: .light)
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
        guard let copiedFormation = performance.formations[safe: index] else {
            return
        }
        let pastedFormation = Formation(
            members: copiedFormation.members.map { Member(relativePosition: $0.relativePosition) },
            memo: copiedFormation.memo
        )
        performanceSettingManager.addFormation(pastedFormation, index: index + 1)
        hapticManager.hapticImpact(style: .medium)
        toastContainerViewModel.presentMessage("레이어가 복제되었습니다")
        tasksQueue.append { [unowned self] in
            currentFormationIndex = index + 1
        }
    }

    func removeFormation(index: Int) {
        performanceSettingManager.removeFormation(index: index)
        hapticManager.hapticImpact(style: .medium)
        toastContainerViewModel.presentMessage("레이어가 삭제되었습니다")
        tasksQueue.append { [unowned self] in
            if formations.isEmpty {
                currentFormationIndex = -1
            } else if index <= currentFormationIndex {
                currentFormationIndex = max(min(currentFormationIndex - 1, formations.count - 1), 0)
            }
        }
    }

    func updateFormationItemFrameMap(_ frame: CGRect, index: Int) {
        formationItemFrameMap[index] = frame
    }

    private func assignControllerToArchiverByZoomed() {
        let controller = isZoomed ? zoomableCanvasController : canvasController
        objectHistoryArchiver.delegate = controller
        performanceSettingManager.relativeCoordinateConverter = controller.relativeCoordinateConverter
    }
}
