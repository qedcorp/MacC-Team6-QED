// Created by byo.

import Foundation

protocol FormationTransitionUseCase {
    var performance: Performance { get }

    func createFormationTransitions() async throws -> [FormationTransition?]

    func updateMovement(
        _ movement: FormationTransition.Movement,
        memberInfo: Member.Info,
        in formationTransition: FormationTransition
    ) async throws

    func removeMovement(
        memberInfo: Member.Info,
        in formationTransition: FormationTransition
    ) async throws
}
