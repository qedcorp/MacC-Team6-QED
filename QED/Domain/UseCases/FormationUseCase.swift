// Created by byo.

import Foundation

protocol FormationUseCase {
    var performance: Performance { get }

    func createFormation(startMs: Int) async throws -> Formation
    func updateFormation(_ formation: Formation) async throws -> Formation
}
