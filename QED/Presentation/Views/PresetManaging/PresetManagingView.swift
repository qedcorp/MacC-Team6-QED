// Created by byo.

import SwiftUI

struct PresetManagingView: View {
    @StateObject private var viewModel = PresetManagingViewModel(
        presetUseCase: DefaultPresetUseCase(
            presetRepository: DefaultPresetRepository(
                remoteManager: FireStoreManager()
            )
        )
    )

    private let objectCanvasViewController = ObjectCanvasViewController()

    var body: some View {
        VStack {
            VStack {
                ObjectCanvasView(controller: objectCanvasViewController, headcount: 5)
                    .frame(height: 240)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.gray.opacity(0.3))
                    )
                    .clipped()
                HStack {
                    HistoryControlsView(historyManagable: objectCanvasViewController.historyManager)
                    Spacer()
                    Button("Generate") {
                        viewModel.generatePreset()
                    }
                }
            }
            .frame(width: 320)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(viewModel.getPresets().enumerated()), id: \.offset) { _, preset in
                        ObjectStageView(formable: preset)
                            .frame(width: 80, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.gray.opacity(0.1))
                            )
                            .clipped()
                            .onTapGesture {
                                viewModel.copyFormable(preset)
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

struct PresetManagingView_Previews: PreviewProvider {
    static var previews: some View {
        PresetManagingView()
    }
}
