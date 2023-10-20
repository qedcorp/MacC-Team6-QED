// Created by byo.

import Foundation

struct LocalPresetRepository: PresetRepository {
    private let userDefaults = UserDefaults.standard
    private let key = "presets"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func createPreset(_ preset: Preset) async throws -> Preset {
        var presets = try getPresets()
        let data = try encoder.encode([preset] + presets)
        userDefaults.set(data, forKey: key)
        return preset
    }

    func readPresets(headcount: Int?) async throws -> [Preset] {
        let presets = try getPresets()
        if let headcount = headcount {
            return presets.filter { $0.headcount == headcount }
        }
        return presets
    }

    private func getPresets() throws -> [Preset] {
        guard let data = userDefaults.data(forKey: key) else {
            return []
        }
        let presets = try decoder.decode([Preset].self, from: data)
        return presets
    }
}
