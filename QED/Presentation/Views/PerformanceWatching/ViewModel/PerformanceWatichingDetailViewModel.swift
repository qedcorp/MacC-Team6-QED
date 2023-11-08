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
                    var arr = map[info.name]
                    arr?.append(path)
                    map[info.color] = arr
                } else {
                    map[info] = [path]
                }
            }
        }

        return map
    }
    var indexDictionary: [ClosedRange<CGFloat>: Int] = [:]
    var action = CurrentValueSubject<ValuePurpose, Never>(.setOffset(0))
    @Published var offset: CGFloat = 0.0
    @Published var playableIndex: Int = 0
    @Published var selectedIndex: Int = 0
    @Published var formationIndex: Int = 0
    private var indexToOffset: [Int: CGFloat] = [:]
    private var player = PlayTimer(timeInterval: 0.03)

    init(performance: Performance) {
        self.performance = performance
        binding()
    }

    private func binding() {
        action
            .sink { [weak self] purpose in
                guard let self = self else { return }
                switch purpose {
                case let .getOffset(offset):
                    self.offset = offset
                    self.changeSelectedIndex(offset: offset)
                case let .getSelctedIndex(index):
                    self.formationIndex = index
                default:
                    break
                }
            }
            .store(in: &bag)
    }

    private func changeSelectedIndex(offset: CGFloat) {
        self.selectedIndex = indexDictionary[offset] ?? 0
    }

    private func mappingIndexFromOffest() {
        var lastX: CGFloat = 0.0
        for formationIndex in performance.formations.indices {
            indexToOffset[formationIndex] = lastX
            let formatationLength = Constants.formationFrame.width + Constants.formationFrame.height
            let range = lastX...(lastX + formatationLength)
            indexDictionary[range] = formationIndex
            lastX += formatationLength + 1.0
        }
    }

    func play() {
        player.startTimer {
            self.offset += 1
            self.action.send(.setOffset(self.offset))
        }
    }

    func pause() {
        player.resetTimer()
    }
}

extension Dictionary where Key == Member.Info {

    internal subscript(color: String) ->  Value? {
        get {
            var answer: Value?
            for element in self {
                if element.key.color == color {
                    answer = element.value
                }
            }
            return answer
        }
        set {
            for element in self {
                if element.key.color == color {
                    self[element.key] = newValue
                }
            }
        }
    }
}
