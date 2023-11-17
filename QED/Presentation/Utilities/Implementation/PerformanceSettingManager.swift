// Created by byo.

import Combine
import Foundation

class PerformanceSettingManager {
    let performance: Performance
    weak var relativeCoordinateConverter: RelativeCoordinateConverter?
    private let performanceUseCase: PerformanceUseCase
    private let changingSubject = PassthroughSubject<PerformanceModel, Never>()
    private var cancellables: Set<AnyCancellable> = []

    lazy var changingPublisher = {
        changingSubject
            .debounce(for: 0.01, scheduler: DispatchQueue.global(qos: .userInitiated))
            .removeDuplicates()
            .eraseToAnyPublisher()
    }()

    init(
        performance: Performance,
        performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    ) {
        self.performance = performance
        self.performanceUseCase = performanceUseCase
        subscribeChangingPublisher()
    }

    private func subscribeChangingPublisher() {
        changingPublisher
            .debounce(for: 3, scheduler: DispatchQueue.global(qos: .userInitiated))
            .sink { _ in
            } receiveValue: { [unowned self] _ in
                Task {
                    try await performanceUseCase.updatePerformance(performance)
                }
            }
            .store(in: &cancellables)
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
            guard let relativePosition = relativeCoordinateConverter?
                .getRelativeValue(of: position, type: RelativePosition.self) else {
                return
            }
            if let member = formation.members[safe: index] {
                member.relativePosition = relativePosition
            } else {
                let member = Member(relativePosition: relativePosition)
                formation.members.append(member)
            }
        }
        updateStartEndOfMovementMap(formationIndex: formationIndex)
        didChange()
    }

    func updateMembers(colors: [String?], formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        colors.enumerated().forEach { index, color in
            let memberInfo = performance.memberInfos?.first { $0.color == color }
            formation.members[safe: index]?.info = memberInfo
        }
        updateStartEndOfMovementMap(formationIndex: formationIndex)
        didChange()
    }

    func updateMembers(movementMap: MovementMap, formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex] else {
            return
        }
        formation.movementMap = movementMap
        didChange()
    }

    func updateMemberInfo(name: String?, color: String, memberInfoIndex: Int) {
        guard let memberInfo = performance.memberInfos?[safe: memberInfoIndex] else {
            return
        }
        memberInfo.name = name
        memberInfo.color = color
        didChange()
    }

    private func updateStartEndOfMovementMap(formationIndex: Int) {
        guard let formation = performance.formations[safe: formationIndex],
              let afterFormation = performance.formations[safe: formationIndex + 1] else {
            return
        }
        var movementMap = formation.movementMap
        formation.members.forEach { member in
            guard let memberInfo = member.info else {
                return
            }
            movementMap?[memberInfo]?.startPosition = member.relativePosition
            if let afterMember = afterFormation.members.first(where: { $0.info === memberInfo }) {
                movementMap?[memberInfo]?.endPosition = afterMember.relativePosition
            }
        }
        formation.movementMap = movementMap
    }

    private func didChange() {
        let performance = PerformanceModel.build(entity: performance)
        changingSubject.send(performance)
    }
}
