//
//  TestPerformanceWatchingViewModel.swift
//  QED
//
//  Created by changgyo seo on 11/7/23.
//
import Foundation

import Combine

class TestPerformanceWatchingViewModel: ObservableObject {
    typealias ValuePurpose = ScrollObservableView.ValuePurpose
    typealias Constants = ScrollObservableView.Constants

    private var bag = Set<AnyCancellable>()
    var performance: Performance
    var movementsMap: MovementsMap {
        // TODO: 함수형으로 바꾸기
        var map = MovementsMap()
        guard let memberInfos = performance.memberInfos else { return [:] }
        for movementMap in performance.formations.map({ $0.movementMap }) {
            for info in memberInfos {
                guard let path = movementMap?[info] else { continue }
                if map[info] != nil {
                    map[info]?.append(path)
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

    func backward() {
        if 0 <= formationIndex - 1 {
            formationIndex -= 1
            action.send(.setSelctedIndex(formationIndex))
        }
    }

    func forward() {
        if performance.formations.count > formationIndex + 1 {
            formationIndex += 1
            action.send(.setSelctedIndex(formationIndex))
        }
    }

    func pause() {
        formationIndex = selectedIndex
    }
}
