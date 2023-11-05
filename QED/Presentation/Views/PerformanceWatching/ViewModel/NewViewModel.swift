//
//  NewViewModel.swift
//  QED
//
//  Created by changgyo seo on 11/3/23.
//

import Foundation

import Combine

class NewViewModel: ObservableObject {

    var bag = Set<AnyCancellable>()

    var performance: Performance
    var movementsMap: MovementsMap {
        // TODO: 함수형으로 바꾸기
        var map = MovementsMap()
        let memberInfos = performance.memberInfos
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
    @Published var offset: CGFloat = 0.0
    @Published var playableIndex: Int = 0
    @Published var selectedIndex: Int = 0

    init(performance: Performance) {
        self.performance = performance
        mappingIndexFromOffest()
        binding()
    }

    private func mappingIndexFromOffest() {
        var lastX: CGFloat = 0.0
        for formationIndex in performance.formations.indices {
            let formatationLength = Constants.frameWidth + Constants.trasitionWidth
            let range = lastX...(lastX + formatationLength)
            indexDictionary[range] = formationIndex
            lastX += formatationLength + 1.0
        }
    }

    private func binding() {
        $offset
            .sink { [weak self] currentOffset in
                guard let self = self else { return }
                // let offset = -currentOffset
                self.selectedIndex = self.indexDictionary[offset] ?? 0
                // offSet당 지나가야하는 index
                var base = CGFloat(PlayableConstants.frameLength) / Constants.frameWidth
                self.playableIndex = Int(round(currentOffset * base))
            }
            .store(in: &bag)
    }
}

extension NewViewModel {
    struct Constants {
        static let frameWidth: CGFloat = 120
        static var ratio: CGFloat {
            CGFloat(PlayableConstants.transitionLength) / CGFloat(PlayableConstants.frameLength)
        }
        static var trasitionWidth: CGFloat {
            Constants.frameWidth * Constants.ratio
        }
    }
}
