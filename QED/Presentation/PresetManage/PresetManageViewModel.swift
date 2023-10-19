// Created by byo.

import Foundation

class PresetManageViewModel: ObservableObject {
    let objectCanvasViewController = ObjectCanvasViewController()
    @Published private(set) var presets: [Preset]

    init(presets: [Preset] = []) {
        self.presets = presets
    }

    func generatePreset() {
        let preset = objectCanvasViewController.generatePreset()
        presets.append(preset)
    }

    func copyPreset(_ preset: Preset) {
        objectCanvasViewController.copyPreset(preset)
    }
}
