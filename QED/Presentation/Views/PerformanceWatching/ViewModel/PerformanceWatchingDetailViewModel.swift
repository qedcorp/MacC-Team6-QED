//
//  PerformanceWatchingDetailViewModel.swift
//  QED
//
//  Created by changgyo seo on 11/7/23.
//

import Combine
import Foundation

@MainActor
class PerformanceWatchingDetailViewModel: ObservableObject {
    typealias ValuePurpose = ScrollObservableView.ValuePurpose
    typealias Constants = ScrollObservableView.Constants
    typealias FrameInfo = ScrollObservableView.FrameInfo
    typealias Controller = ObjectMovementAssigningViewController

    private var performanceSettingManager: PerformanceSettingManager?
    private var toastContainerViewModel: ToastContainerViewModel?
    private let player = PlayTimer(timeInterval: 0.03)

    private(set) lazy var movementController = {
        let controller = Controller()
        controller.objectHistoryArchiver = objectHistoryArchiver
        return controller
    }()

    private(set) lazy var zoomableMovementController = {
        let controller = Controller()
        controller.objectHistoryArchiver = objectHistoryArchiver
        return controller
    }()

    private(set) lazy var objectHistoryArchiver = {
        ObjectHistoryArchiver<Controller.History>()
    }()

    @Published var performance: PerformanceModel?
    @Published var isAllFormationVisible = false
    @Published var isAutoShowAllForamation = false
    @Published var isSettingSheetVisible = false
    @Published var isNameVisiable = true
    @Published var isBeforeVisible = false
    @Published var isLineVisible = false
    @Published var isLoading = true
    @Published var offset: CGFloat = 0
    @Published var selectedIndex = 0
    @Published var currentMemo = ""

    @Published var isTransitionEditable = false {
        didSet {
            if isTransitionEditable {
                pause()
            }
        }
    }

    @Published var isPlaying = false {
        didSet {
            if isPlaying {
                isTransitionEditable = false
            }
        }
    }

    @Published var isZoomed = false {
        didSet { assignControllerToArchiverByZoomed() }
    }

    private(set) var action = CurrentValueSubject<ValuePurpose, Never>(.setOffset(0))
    private var offsetMap: [ClosedRange<CGFloat>: FrameInfo] = [:]
    private var bag = Set<AnyCancellable>()

    var currentIndex: Int {
        offsetMap[offset]?.index ?? -1
    }

    var currentFormation: Formation? {
        performance?.formations[safe: currentIndex]?.entity
    }

    var beforeFormation: Formation? {
        performance?.formations[safe: currentIndex - 1]?.entity
    }

    var movementMapTag: String {
        String(describing: currentFormation?.movementMap)
    }

    var movementsMap: MovementsMap? {
        // TODO: 함수형으로 바꾸기
        guard let performance = performance,
              let memberInfos = performance.entity.memberInfos else {
            return nil
        }
        var map = MovementsMap()
        let movementsMap = performance.formations.map { $0.movementMap }
        for index in movementsMap.indices {
            var movementMap = movementsMap[index]
            if movementMap?.isEmpty ?? true {
                if index < movementsMap.count - 1 {
                    movementMap = makeLinearMovementMap(memberInfos,
                                                        startFormation: performance.formations[index],
                                                        endFormation: performance.formations[index + 1]
                    )
                } else {
                    movementMap = makeLinearMovementMap(memberInfos,
                                                        startFormation: performance.formations[index],
                                                        endFormation: performance.formations[index]
                    )
                }
            }
            for info in memberInfos {
                guard let path = movementMap?[info.color] else { continue }
                if map[info.color] != nil {
                    var arr = map[info.color]
                    arr?.append(path)
                    map[info.color] = arr
                } else {
                    map[info] = [path]
                }
            }
        }
        return map
    }

    var isNavigationBarHidden: Bool {
        isZoomed
    }

    func setupWithDependency(_ dependency: PerformanceWatchingViewDependency) {
        performance = nil
        DispatchQueue.main.async { [unowned self] in
            if let entity = dependency.performanceSettingManager?.performance {
                performance = .build(entity: entity)
            }
            isAllFormationVisible = dependency.isAllFormationVisible
            performanceSettingManager = dependency.performanceSettingManager
            toastContainerViewModel = dependency.toastContainerViewModel
            bindingPublishers()
            mappingIndexFromOffset()
            subscribePerformanceSettingManager()
            assignControllerToArchiverByZoomed()
        }
    }

    private func bindingPublishers() {
        action
            .sink { [weak self] purpose in
                guard let self = self else { return }
                switch purpose {
                case let .getSelctedIndex(index):
                    self.selectedIndex = index
                case let .getOffset(offset):
                    self.offset = offset
                    guard let currentIndex = offsetMap[offset] else { return }
                    action.send(.getSelctedIndex(currentIndex.index))
                case let .setSelctedIndex(index):
                    for element in offsetMap {
                        let framInfo = element.value
                        if framInfo == .formation(index: index) {
                            action.send(.setOffset(element.key.lowerBound))
                        }
                    }
                default:
                    break
                }
            }
            .store(in: &bag)

        $selectedIndex
            .sink { [unowned self] index in
                currentMemo = performance?.entity.formations[index].memo ?? "대형 \(index + 1)"
            }
            .store(in: &bag)
    }

    private func mappingIndexFromOffset() {
        guard let performance = performance else {
            return
        }
        var lastX: CGFloat = 0.0
        for formationIndex in performance.formations.indices {
            let formatationLength = Constants.formationFrame.width + Constants.trasitionFrame.width
            let formationRange = lastX...(lastX + Constants.formationFrame.width)
            let transtionRange = (lastX + Constants.formationFrame.width)...(lastX + formatationLength)
            offsetMap[formationRange] = .formation(index: formationIndex)
            offsetMap[transtionRange] = .transition(index: formationIndex)
            lastX += formatationLength
        }
    }

    private func subscribePerformanceSettingManager() {
        performanceSettingManager?.changingPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [unowned self] in
                performance = $0
            }
            .store(in: &bag)
    }

    func play() {
        guard let performance = performance else {
            return
        }
        isPlaying = true
        player.startTimer { [unowned self] in
            guard let currentFramInfo = offsetMap[offset] else {
                pause()
                return
            }
            if currentFramInfo.isSameFrame(.transition()) {
                offset += 0.5
                action.send(.setOffset(offset))
            } else {
                offset += 1
                action.send(.setOffset(offset))
            }
            let totalFormationLength = Constants.formationFrame.width * CGFloat(performance.formations.count)
            let totalTransitionLength = Constants.trasitionFrame.width * CGFloat(performance.formations.count - 1)
            if offset > totalFormationLength + totalTransitionLength {
                offset = totalFormationLength + totalTransitionLength
                pause()
            }
        }
    }

    func pause() {
        isPlaying = false
        player.resetTimer()
    }

    func toggleZoom() {
        animate {
            isZoomed.toggle()
        }
    }

    func presentEditingModeToastMessage() {
        toastContainerViewModel?.presentMessage("동선추가 기능이 켜졌습니다")
    }

    func updateMembers(movementMap: MovementMap) {
        performanceSettingManager?.updateMembers(movementMap: movementMap, formationIndex: currentIndex)
    }

    private func makeLinearMovementMap(
        _ memberInfos: [Member.Info],
        startFormation: FormationModel,
        endFormation: FormationModel
    ) -> MovementMap {
        var movementMap = MovementMap()
        for memberInfo in memberInfos {
            guard let startPoint = startFormation.members
                .first(where: { $0.color == memberInfo.color })?
                .relativePosition,
            let endPoint = endFormation.members
                .first(where: { $0.color == memberInfo.color })?
                .relativePosition else { continue }
            movementMap[memberInfo] = BezierPath(
                startPosition: startPoint,
                endPosition: endPoint
            )
        }
        return movementMap
    }

    private func assignControllerToArchiverByZoomed() {
        let controller = isZoomed ? zoomableMovementController : movementController
        objectHistoryArchiver.delegate = controller
    }
}

fileprivate extension Dictionary where Key == Member.Info {
    subscript(color: String) -> Value? {
        get {
            for element in self where element.key.color == color {
                return element.value
            }
            return nil
        }
        set {
            for element in self where element.key.color == color {
                self[element.key] = newValue
            }
        }
    }
}
