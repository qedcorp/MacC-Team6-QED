// Created by byo.

import Foundation

@MainActor
class PresetManagingViewModel: ObservableObject {
    typealias Controller = ObjectCanvasViewController

    let canvasController: Controller
    let objectHistoryArchiver: ObjectHistoryArchiver<Controller.History>
    let presetUseCase: PresetUseCase
    @Published var headcount = 5
    @Published var historyTag = ""
    @Published private(set) var presets: [Preset] = []

    init(presetUseCase: PresetUseCase = DIContainer.shared.resolver.resolve(PresetUseCase.self)) {
        let canvasController = Controller()
        let objectHistoryArchiver = ObjectHistoryArchiver<Controller.History>()
        canvasController.objectHistoryArchiver = objectHistoryArchiver
        objectHistoryArchiver.delegate = canvasController
        self.canvasController = canvasController
        self.objectHistoryArchiver = objectHistoryArchiver
        self.presetUseCase = presetUseCase
    }

    func fetchPresets() {
        Task {
            presets = try await presetUseCase.getPresets(headcount: nil)
        }
    }

    func updatePreset(id: String) {
        let preset = canvasController.getPreset(id: id)
        Task {
            try await presetUseCase.updatePreset(preset)
        }
    }

    func createPreset() {
        let preset = canvasController.getPreset()
        presets.insert(preset, at: 0)
        Task {
            try await presetUseCase.createPreset(preset)
        }
    }
}
