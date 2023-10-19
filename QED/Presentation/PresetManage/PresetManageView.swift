// Created by byo.

import SwiftUI

struct PresetManageView: View {
    @StateObject private var viewModel = PresetManageViewModel(
        presetUseCase: DefaultPresetUseCase(presetRepository: LocalPresetRepository())
    )

    private let objectCanvasViewController = ObjectCanvasViewController()

    var body: some View {
        VStack {
            ObjectCanvasView(controller: objectCanvasViewController)
                .frame(width: 320, height: 240)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray.opacity(0.3))
                )
                .clipped()
            Button("Generate") {
                viewModel.generatePreset()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(viewModel.getPresets().enumerated()), id: \.offset) { _, preset in
                        ObjectStageView(preset: preset)
                            .frame(width: 80, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.gray.opacity(0.1))
                            )
                            .clipped()
                            .onTapGesture {
                                viewModel.copyPreset(preset)
                            }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchPresets()
            }
        }
        .onAppear {
            viewModel.objectCanvasViewController = objectCanvasViewController
        }
    }
}

struct PresetManageView_Previews: PreviewProvider {
    static var previews: some View {
        PresetManageView()
    }
}
