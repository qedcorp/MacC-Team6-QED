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

    @Published private(set) var performance: PerformanceModel?
    @Published var isAllFormationVisible = false
    @Published var isAutoShowAllForamation = false
    @Published var offset: CGFloat = 0.0
    @Published var selectedIndex: Int = 0
    @Published var isPlaying = false

    @Published private(set) var isZoomed = false {
        didSet { assignControllerToArchiverByZoomed() }
    }

    private(set) var action = CurrentValueSubject<ValuePurpose, Never>(.setOffset(0))
    private var offsetMap: [ClosedRange<CGFloat>: FrameInfo] = [:]
    private var player = PlayTimer(timeInterval: 0.03)
    private var bag = Set<AnyCancellable>()

    var beforeFormation: Formation? {
        performance?.formations[safe: currentIndex]?.entity
    }

    var afterFormation: Formation? {
        performance?.formations[safe: currentIndex + 1]?.entity
    }

    var currentFormationTag: String {
        String(describing: performance?.formations[safe: currentIndex]?.movementMap)
    }

    var currentIndex: Int {
        offsetMap[offset]?.index ?? -1
    }

    var movementsMap: MovementsMap {
        // TODO: 함수형으로 바꾸기
        var map = MovementsMap()
        guard let performance = performance,
              let memberInfos = performance.entity.memberInfos else {
            return [:]
        }
        let movementsMap = performance.entity.formations.map({ $0.movementMap })
        for index in movementsMap.indices {
            var movementMap = movementsMap[index]
            if movementMap == nil {
                if index <= movementsMap.count - 2 {
                    movementMap = makeLinearMovementMap(memberInfos,
                                                        startFormation: performance.entity.formations[index],
                                                        endFormation: performance.entity.formations[index + 1]
                    )
                } else {
                    movementMap = makeLinearMovementMap(memberInfos,
                                                        startFormation: performance.entity.formations[index],
                                                        endFormation: performance.entity.formations[index]
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

    func setupWithDependency(_ dependency: PerformanceWatchingViewDependency) {
        isAllFormationVisible = dependency.isAllFormationVisible
        if let entity = dependency.performanceSettingManager?.performance {
            performance = .build(entity: entity)
        }
        performanceSettingManager = dependency.performanceSettingManager
        binding()
        mappingIndexFromOffest()
        subscribePerformanceSettingManager()
        assignControllerToArchiverByZoomed()
    }

    private func binding() {
        action
            .sink { [weak self] purpose in
                guard let self = self else { return }
                switch purpose {
                case let .getOffset(offset):
                    self.offset = offset
                default:
                    break
                }
            }
            .store(in: &bag)

        $selectedIndex
            .sink { index in
                for element in self.offsetMap {
                    let framInfo = element.value
                    if framInfo == .formation(index: index) {
                        self.action.send(.setOffset(element.key.lowerBound))
                    }
                }
            }
            .store(in: &bag)
    }

    private func mappingIndexFromOffest() {
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
        player.startTimer {
            guard let currentFramInfo = self.offsetMap[self.offset] else {
                self.player.resetTimer()
                self.isPlaying = false
                return
            }
            if currentFramInfo.isSameFrame(.transition()) {
                self.offset += 0.5
                self.action.send(.setOffset(self.offset))
            } else {
                self.offset += 1
                self.action.send(.setOffset(self.offset))
            }
            let totalFormationLength = Constants.formationFrame.width * CGFloat(performance.formations.count)
            let totalTransitionLength = Constants.trasitionFrame.width * CGFloat(performance.formations.count - 1)
            if self.offset >  totalFormationLength + totalTransitionLength {
                self.player.resetTimer()
                self.offset = totalFormationLength + totalTransitionLength
                self.isPlaying = false
            }
        }
    }

    func pause() {
        player.resetTimer()
    }

    func updateMembers(movementMap: MovementMap) {
        performanceSettingManager?.updateMembers(movementMap: movementMap, formationIndex: currentIndex)
    }

    func toggleZoom() {
        animate {
            isZoomed.toggle()
        }
    }

    private func makeLinearMovementMap(
        _ memberInfos: [Member.Info],
        startFormation: Formation,
        endFormation: Formation
    ) -> MovementMap {
        var movementMap = MovementMap()
        for memberInfo in memberInfos {
            guard let startPoint = startFormation.members
                .first(where: { $0.info?.color == memberInfo.color })?
                .relativePosition,
            let endPoint = endFormation.members
                .first(where: { $0.info?.color == memberInfo.color })?
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

extension Dictionary where Key == Member.Info {

    internal subscript(color: String) ->  Value? {
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
