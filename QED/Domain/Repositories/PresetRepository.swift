// Created by byo.

import Foundation

protocol PresetRepository {
    func createPreset(_ preset: Preset) async throws -> Preset
    func readPresets(headcount: Int) async throws -> [Preset]
}
