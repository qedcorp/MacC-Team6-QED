// Created by byo.

import Foundation

struct DefaultFormationTransitionUseCase: FormationTransitionUseCase {
    let performance: Performance

    func createFormationTransitions() async throws -> [FormationTransition] {
        (0 ..< performance.formations.count)
            .map { _ in FormationTransition() }
    }

    func updateMovement(_ movement: FormationTransition.Movement, memberInfo: Member.Info, in formationTransition: FormationTransition) async throws {
        formationTransition.memberMovements[memberInfo] = movement
    }

    func removeMovement(memberInfo: Member.Info, in formationTransition: FormationTransition) async throws {
        formationTransition.memberMovements.removeValue(forKey: memberInfo)
    }
}
