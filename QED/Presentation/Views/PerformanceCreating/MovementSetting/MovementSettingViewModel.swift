// Created by byo.

import Combine
import Foundation

@MainActor
class MovementSettingViewModel: ObservableObject {
    typealias Controller = ObjectMovementAssigningViewController

    @Published private(set) var performance: PerformanceModel

    @Published private(set) var currentFormationIndex = 0 {
        didSet { objectHistoryArchiver.reset() }
    }

    @Published private(set) var isZoomed = false {
        didSet { assignControllerToArchiverByZoomed() }
    }

    let movementController: Controller
    let zoomableMovementController: Controller
    let objectHistoryArchiver: ObjectHistoryArchiver<Controller.History>
    let performanceSettingManager: PerformanceSettingManager
    private var cancellables: Set<AnyCancellable> = []

    init(performanceSettingManager: PerformanceSettingManager) {
        let movementController = Controller()
        let zoomableMovementController = Controller()
        let objectHistoryArchiver = ObjectHistoryArchiver<Controller.History>()

        movementController.objectHistoryArchiver = objectHistoryArchiver
        zoomableMovementController.objectHistoryArchiver = objectHistoryArchiver

        self.performance = .build(entity: performanceSettingManager.performance)
        self.movementController = movementController
        self.zoomableMovementController = zoomableMovementController
        self.objectHistoryArchiver = objectHistoryArchiver
        self.performanceSettingManager = performanceSettingManager

        subscribePerformanceSettingManager()
        assignControllerToArchiverByZoomed()
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

    var beforeFormation: FormationModel? {
        performance.formations[safe: currentFormationIndex]
    }

    var afterFormation: FormationModel? {
        performance.formations[safe: currentFormationIndex + 1]
    }

    var currentFormationTag: String {
        String(describing: performance.formations[safe: currentFormationIndex]?.movementMap)
    }

    func updateMembers(movementMap: MovementMap) {
        performanceSettingManager.updateMembers(movementMap: movementMap, formationIndex: currentFormationIndex)
    }

    func gotoBefore() {
        guard currentFormationIndex > 0 else {
            return
        }
        animate {
            currentFormationIndex -= 1
        }
    }

    func gotoAfter() {
        guard currentFormationIndex < performance.formations.count - 2 else {
            return
        }
        animate {
            currentFormationIndex += 1
        }
    }

    func toggleZoom() {
        animate {
            isZoomed.toggle()
        }
    }

    private func assignControllerToArchiverByZoomed() {
        let controller = isZoomed ? zoomableMovementController : movementController
        objectHistoryArchiver.delegate = controller
        performanceSettingManager.relativeCoordinateConverter = controller.relativeCoordinateConverter
    }
}
