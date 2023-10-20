// Created by byo.

import Foundation

@MainActor
class PresetContainerViewModel: ObservableObject {
    let presetUseCase: PresetUseCase
    weak var objectCanvasViewController: ObjectCanvasViewController?
    @Published var isGridPresented = false
    @Published private var presets: [Preset] = []

    init(presetUseCase: PresetUseCase) {
        self.presetUseCase = presetUseCase
    }

    func fetchPresets() {
        Task {
            presets = try await presetUseCase.getPresets(headcount: nil)
        }
    }

    func copyFormable(_ preset: Preset) {
        objectCanvasViewController?.copyFormable(preset)
    }

    func getPresets() -> [Preset] {
        [.empty] + presets
    }
}
