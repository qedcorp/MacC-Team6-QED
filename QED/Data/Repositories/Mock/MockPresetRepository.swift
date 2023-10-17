// Created by byo.

import Foundation

class MockPresetRepository: PresetRepository {
    private var presets: [Preset] = []
    
    func createPreset(_ preset: Preset) async throws -> Preset {
        presets.append(preset)
        return preset
    }
    
    func readPresets(headcount: Int) async throws -> [Preset] {
        presets
    }
}
