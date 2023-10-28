// Created by byo.

import Combine
import Foundation

class PerformanceSettingManager {
    let performance: Performance
    let sizeable: Sizeable?
    private let changedSubject = PassthroughSubject<PerformanceModel, Never>()

    lazy var changedPublisher = {
        changedSubject.eraseToAnyPublisher()
    }()

    private lazy var relativePositionConverter: RelativePositionConverter? = {
        guard let sizeable = sizeable else {
            return nil
        }
        return RelativePositionConverter(sizeable: sizeable)
    }()

    init(performance: Performance, sizeable: Sizeable? = nil) {
        self.performance = performance
        self.sizeable = sizeable
    }

    func addFormation(_ formation: Formation, index: Int) {
        performance.formations.insert(formation, at: index)
        didChange()
    }

    func removeFormation(index: Int) {
        performance.formations.remove(at: index)
        didChange()
    }

    func updateMemo(_ memo: String, formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        formation.memo = memo
        didChange()
    }

    func updateMembers(positions: [CGPoint], formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        formation.members = Array(formation.members.prefix(positions.count))
        positions.enumerated().forEach { index, position in
            guard let relativePosition = relativePositionConverter?.getRelativePosition(of: position) else {
                return
            }
            if let member = formation.members[safe: index] {
                member.relativePosition = relativePosition
            } else {
                let member = Member(relativePosition: relativePosition)
                formation.members.append(member)
            }
        }
        didChange()
    }

    func updateMembers(colors: [String?], formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        colors.enumerated().forEach { index, color in
            let memberInfo = performance.memberInfos.first { $0.color == color }
            formation.members[safe: index]?.info = memberInfo
        }
        didChange()
    }

    func updateMemberName(_ name: String, memberInfoIndex: Int) {
        guard let memberInfo = performance.memberInfos[safe: memberInfoIndex] else {
            return
        }
        memberInfo.name = name
        didChange()
    }

    private func didChange() {
        let performance = PerformanceModel.build(entity: performance)
        changedSubject.send(performance)
    }
}
