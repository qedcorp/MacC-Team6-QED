// Created by byo.

import Foundation

struct DefaultFormationUseCase: FormationUseCase {
    let performance: Performance

    func createFormation(startMs: Int) async throws -> Formation {
        let formation = Formation(startMs: startMs)
        performance.formations.append(formation)
        return formation
    }
}
