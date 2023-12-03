// Created by byo.

import Foundation

protocol PresetRepository {
    func updatePreset(_ preset: Preset) async throws -> Preset
    func createPreset(_ preset: Preset) async throws -> Preset
    func readPresets(headcount: Int?) async throws -> [Preset]
}
