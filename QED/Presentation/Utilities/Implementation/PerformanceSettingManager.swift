// Created by byo.

import Foundation

class PerformanceSettingManager {
    let performance: Performance
    let sizeable: Sizeable

    private lazy var relativePositionConverter = {
        RelativePositionConverter(sizeable: sizeable)
    }()

    init(performance: Performance, sizeable: Sizeable) {
        self.performance = performance
        self.sizeable = sizeable
    }

    func addFormation(_ formation: Formation, index: Int) {
        performance.formations.insert(formation, at: index)
    }

    func removeFormation(index: Int) {
        performance.formations.remove(at: index)
    }

    func updateMembers(positions: [CGPoint], formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        positions.enumerated().forEach { index, position in
            let relativePosition = relativePositionConverter.getRelativePosition(of: position)
            formation.members[safe: index]?.relativePosition = relativePosition
        }
    }

    func updateMembers(memberInfos: [Member.Info], formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        memberInfos.enumerated().forEach { index, memberInfo in
            formation.members[safe: index]?.info = memberInfo
        }
    }
}
