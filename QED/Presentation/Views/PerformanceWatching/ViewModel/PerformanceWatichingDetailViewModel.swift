//
//  PerformanceWatichingDetailViewModel.swift
//  QED
//
//  Created by changgyo seo on 11/7/23.
//
import Foundation

import Combine

class PerformanceWatichingDetailViewModel: ObservableObject {
    typealias ValuePurpose = ScrollObservableView.ValuePurpose
    typealias Constants = ScrollObservableView.Constants

    private var bag = Set<AnyCancellable>()

    var performance: Performance
    var movementsMap: MovementsMap {
        // TODO: 함수형으로 바꾸기
        var map = MovementsMap()
        guard let memberInfos = performance.memberInfos else { return [:] }
        let movementsMap = performance.formations.map({ $0.movementMap })
        for movementMap in movementsMap {
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
    private var indexDictionary: [ClosedRange<CGFloat>: Int] = [:]
    private var isTrasition: [ClosedRange<CGFloat>: Int] = [:]
    private var isFormation: [ClosedRange<CGFloat>: Int] = [:]
    private var player = PlayTimer(timeInterval: 0.03)

    init(performance: Performance) {
        self.performance = performance
        binding()
        mappingIndexFromOffest()
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
                self.action.send(.setSelctedIndex(index))
            }
            .store(in: &bag)
    }

    private func mappingIndexFromOffest() {
        var lastX: CGFloat = 0.0
        for formationIndex in performance.formations.indices {
            let formatationLength = Constants.formationFrame.width + Constants.trasitionFrame.width
            let range = lastX...(lastX + formatationLength)
            let formationRange = lastX...(lastX + Constants.formationFrame.width)
            let transtionRange = (lastX + Constants.formationFrame.width + 1)...(lastX + formatationLength)
            indexDictionary[range] = formationIndex
            isFormation[formationRange] = formationIndex
            isTrasition[transtionRange] = formationIndex
            lastX += formatationLength + 1.0
        }
    }

    func play() {
        player.startTimer {
            if self.isFormation[self.offset] == nil {
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
