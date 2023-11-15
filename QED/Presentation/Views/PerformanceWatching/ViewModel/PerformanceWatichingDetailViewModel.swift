//
//  PerformanceWatichingDetailViewModel.swift
//  QED
//
//  Created by changgyo seo on 11/7/23.
//
import Foundation

import Combine

@MainActor
class PerformanceWatichingDetailViewModel: ObservableObject {
    typealias ValuePurpose = ScrollObservableView.ValuePurpose
    typealias Constants = ScrollObservableView.Constants
    typealias FrameInfo = ScrollObservableView.FrameInfo

    private var bag = Set<AnyCancellable>()

    var performance: Performance
    var movementsMap: MovementsMap {
        // TODO: 함수형으로 바꾸기
        var map = MovementsMap()
        guard let memberInfos = performance.memberInfos else { return [:] }
        let movementsMap = performance.formations.map({ $0.movementMap })
        for index in movementsMap.indices {
            var movementMap = movementsMap[index]
            if movementMap == nil {
                if index < movementsMap.count - 2 {
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

    private(set) var action = CurrentValueSubject<ValuePurpose, Never>(.setOffset(0))
    @Published var offset: CGFloat = 0.0
    @Published var selectedIndex: Int = 0
    @Published var isPlaying = false
    private var offsetMap: [ClosedRange<CGFloat>: FrameInfo] = [:]
    private var player = PlayTimer(timeInterval: 0.03)

    init(performance: Performance) {
        self.performance = performance
        binding()
        mappingIndexFromOffest()
    }

    var currentIndex: Int {
        offsetMap[offset]?.index ?? -1
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

    func play() {
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
            let totalFormationLength = Constants.formationFrame.width * CGFloat(self.performance.formations.count)
            let totalTransitionLength = Constants.trasitionFrame.width * CGFloat(self.performance.formations.count - 1)
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
