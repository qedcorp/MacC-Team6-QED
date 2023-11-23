// Created by byo.

import Combine
import Foundation

class PerformanceSettingManager {
    let performance: Performance
    let isAutoUpdateDisabled: Bool
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
        isAutoUpdateDisabled: Bool = false,
        performanceUseCase: PerformanceUseCase = DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    ) {
        self.performance = performance
        self.isAutoUpdateDisabled = isAutoUpdateDisabled
        self.performanceUseCase = performanceUseCase
        subscribeChangingPublisher()
    }

    private func subscribeChangingPublisher() {
        changingPublisher
            .debounce(for: 3, scheduler: DispatchQueue.global(qos: .userInitiated))
            .sink { _ in
            } receiveValue: { [unowned self] _ in
                guard !isAutoUpdateDisabled else {
                    return
                }
                Task {
                    try await requestUpdate()
                }
            }
            .store(in: &cancellables)
    }

    func requestUpdate() async throws {
        try await performanceUseCase.updatePerformance(performance)
    }

    func addFormation(_ formation: Formation, index: Int) {
        performance.formations.insert(formation, at: index)
        refreshMovementMaps()
        didChange()
    }

    func removeFormation(index: Int) {
        performance.formations.remove(at: index)
        refreshMovementMaps()
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
        refreshMovementMaps()
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
        refreshMovementMaps()
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

    func updatePerformanceTitle(with title: String) {
        if !title.isEmpty {
            performance.title = title
            didChange()
        }
    }

    private func refreshMovementMaps() {
        for index in 0 ..< performance.formations.count {
            updateStartEndOfMovementMap(formationIndex: index)
        }
    }

    private func updateStartEndOfMovementMap(formationIndex: Int) {
        guard let beforeFormation = performance.formations[safe: formationIndex - 1],
              let formation = performance.formations[safe: formationIndex] else {
            return
        }
        var movementMap = beforeFormation.movementMap
        formation.members.forEach { member in
            guard let info = member.info else {
                return
            }
            if let beforeMember = beforeFormation.members.first(where: { $0.info?.color == info.color }) {
                movementMap?[info.color]?.startPosition = beforeMember.relativePosition
            }
            movementMap?[info.color]?.endPosition = member.relativePosition
        }
        beforeFormation.movementMap = movementMap
    }

    private func didChange() {
        let performance = PerformanceModel.build(entity: performance)
        changingSubject.send(performance)
    }
}
