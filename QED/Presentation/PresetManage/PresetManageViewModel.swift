// Created by byo.

import Foundation

@MainActor
class PresetManageViewModel: ObservableObject {
    let presetUseCase: PresetUseCase
    weak var objectCanvasViewController: ObjectCanvasViewController?
    @Published private var presets: [Preset] = []

    init(presetUseCase: PresetUseCase) {
        self.presetUseCase = presetUseCase
    }

    func fetchPresets() {
        Task {
            presets = try await presetUseCase.getPresets(headcount: nil)
        }
    }

    func generatePreset() {
        guard let preset = objectCanvasViewController?.generatePreset() else {
            return
        }
        presets.insert(preset, at: 0)
        Task {
            try await presetUseCase.createPreset(preset)
        }
    }

    func copyFormable(_ preset: Preset) {
        objectCanvasViewController?.copyFormable(preset)
    }

    func getPresets() -> [Preset] {
        [.empty] + presets
    }
}
