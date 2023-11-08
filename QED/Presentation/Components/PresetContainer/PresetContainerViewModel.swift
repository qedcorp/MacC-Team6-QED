// Created by byo.

import Foundation

@MainActor
class PresetContainerViewModel: ObservableObject {
    let headcount: Int?
    let canvasController: ObjectCanvasViewController
    let presetUseCase: PresetUseCase
    @Published private(set) var presets: [Preset] = []
    @Published private(set) var isGridPresented = false

    init(
        headcount: Int?,
        canvasController: ObjectCanvasViewController,
        presetUseCase: PresetUseCase = DIContainer.shared.resolver.resolve(PresetUseCase.self)
    ) {
        self.headcount = headcount
        self.canvasController = canvasController
        self.presetUseCase = presetUseCase
    }

    func fetchPresets() {
        Task {
            presets = try await presetUseCase.getPresets(headcount: headcount)
        }
    }

    func toggleGrid(isPresented: Bool? = nil) {
        animate {
            if let isPresented = isPresented {
                isGridPresented = isPresented
            } else {
                isGridPresented.toggle()
            }
        }
    }
}
