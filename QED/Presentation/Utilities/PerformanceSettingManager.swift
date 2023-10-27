// Created by byo.

import Foundation

struct PerformanceSettingManager {
    let performance: Performance
    let sizeable: Sizeable

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
            let relativePosition = getRelativePosition(position)
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

    private func getRelativePosition(_ position: CGPoint) -> RelativePosition {
        RelativePosition(
            x: Int(round(position.x / sizeable.size.width * CGFloat(RelativePosition.maxX))),
            y: Int(round(position.y / sizeable.size.height * CGFloat(RelativePosition.maxY)))
        )
    }
}
