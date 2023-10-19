// Created by byo.

import Foundation

protocol PresetUseCase {
    func createPreset(_ preset: Preset) async throws -> Preset
    func getPresets(headcount: Int?) async throws -> [Preset]
}
