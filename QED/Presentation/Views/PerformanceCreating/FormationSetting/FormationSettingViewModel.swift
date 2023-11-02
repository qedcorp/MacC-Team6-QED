// Created by byo.

import Combine
import Foundation

@MainActor
class FormationSettingViewModel: ObservableObject {
    typealias Controller = ObjectCanvasViewController

    @Published var performance: PerformanceModel
    @Published var isMemoFormPresented = false
    @Published var currentFormationIndex = -1

    @Published var isZoomed = false {
        didSet { assignControllerToArchiverByZoomed() }
    }

    let canvasController: Controller
    let zoomableCanvasController: Controller
    let objectHistoryArchiver: ObjectHistoryArchiver<Controller.History>
    let performanceSettingManager: PerformanceSettingManager
    let performanceUseCase: PerformanceUseCase
    private var tasksQueue: [() -> Void] = []
    private var cancellables: Set<AnyCancellable> = []

    init(
        performance: Performance,
        performanceUseCase: PerformanceUseCase
    ) {
        let canvasController = Controller()
        let zoomableCanvasController = Controller()
        let objectHistoryArchiver = ObjectHistoryArchiver<Controller.History>()
        let performanceSettingManager = PerformanceSettingManager(
            performance: performance,
            performanceUseCase: performanceUseCase
        )

        self.performance = .build(entity: performance)
        self.canvasController = canvasController
        self.zoomableCanvasController = zoomableCanvasController
        self.objectHistoryArchiver = objectHistoryArchiver
        self.performanceSettingManager = performanceSettingManager
        self.performanceUseCase = performanceUseCase

        canvasController.objectHistoryArchiver = objectHistoryArchiver
        zoomableCanvasController.objectHistoryArchiver = objectHistoryArchiver

        subscribePerformanceSettingManager()
        assignControllerToArchiverByZoomed()
        addFormation()
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager.changingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] in
                performance = $0
                executePendingTasks()
            }
            .store(in: &cancellables)
    }

    private func executePendingTasks() {
        while !tasksQueue.isEmpty {
            tasksQueue.popLast()?()
        }
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
        tasksQueue.append { [unowned self] in
            isMemoFormPresented = false
        }
    }

    func updateMembers(positions: [CGPoint]) {
        performanceSettingManager.updateMembers(positions: positions, formationIndex: currentFormationIndex)
    }

    func addFormation() {
        let formation = Formation()
        performanceSettingManager.addFormation(formation, index: currentFormationIndex + 1)
        tasksQueue.append { [unowned self] in
            currentFormationIndex += 1
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
        tasksQueue.append { [unowned self] in
            currentFormationIndex = index + 1
        }
    }

    func removeFormation(index: Int) {
        performanceSettingManager.removeFormation(index: index)
        tasksQueue.append { [unowned self] in
            if index <= currentFormationIndex {
                currentFormationIndex = min(currentFormationIndex - 1, formations.count - 1)
            }
        }
    }

    private func assignControllerToArchiverByZoomed() {
        let controller = isZoomed ? zoomableCanvasController : canvasController
        objectHistoryArchiver.delegate = controller
        performanceSettingManager.relativeCoordinateConverter = controller.relativeCoordinateConverter
    }
}
