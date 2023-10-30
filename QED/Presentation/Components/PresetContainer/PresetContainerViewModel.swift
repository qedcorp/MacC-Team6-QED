// Created by byo.

import Foundation

@MainActor
class PresetContainerViewModel: ObservableObject {
    let presetUseCase: PresetUseCase
    var headcount: Int?
    @Published var isGridPresented = false
    @Published private(set) var presets: [Preset] = []

    init(presetUseCase: PresetUseCase) {
        self.presetUseCase = presetUseCase
    }

    func fetchPresets() {
        Task {
            presets = try await presetUseCase.getPresets(headcount: headcount)
        }
    }
}
