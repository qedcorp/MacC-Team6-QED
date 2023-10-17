// Created by byo.

import Foundation

struct DefaultPresetUseCase: PresetUseCase {
    let presetRepository: PresetRepository

    func createPreset(_ preset: Preset) async throws -> Preset {
        try await presetRepository.createPreset(preset)
    }

    func getPresets(headcount: Int) async throws -> [Preset] {
        try await presetRepository.readPresets(headcount: headcount)
    }
}
