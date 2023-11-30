// Created by byo.

import SwiftUI

struct PresetManagingView: View {
    @StateObject private var viewModel = PresetManagingViewModel()
    @State var currentPresetId: String = ""

    var body: some View {
        VStack {
            VStack {
                Stepper("", value: $viewModel.headcount, in: 2...13)
                Text("\(viewModel.headcount)인")
                ObjectCanvasView(
                    controller: viewModel.canvasController,
                    formable: nil,
                    headcount: viewModel.headcount,
                    onChange: {
                        viewModel.historyTag = String(describing: $0)
                    }
                )
                .aspectRatio(19 / 12, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray.opacity(0.3))
                )
                .clipped()
                HStack {
                    HistoryControlsView(
                        historyControllable: viewModel.objectHistoryArchiver,
                        tag: viewModel.historyTag
                    )
                    Rectangle().foregroundStyle(.clear).frame(height: 1)
                    Button("Update") {
                        viewModel.updatePreset(id: currentPresetId)
                    }
                    Spacer(minLength: 12)
                    Button("Generate") {
                        viewModel.createPreset()
                    }
                }
            }
            .frame(width: 320)
            ScrollView(.horizontal) {
                HStack {
                    buildObjectStageView(formable: Preset.empty)
                    ForEach(Array(viewModel.presets.sorted { $0.id < $1.id } .enumerated()), id: \.offset) { _, preset in
                        VStack {
                            buildObjectStageView(formable: preset)
                            Text(preset.id)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                viewModel.fetchPresets()
            }
        }
        .navigationTitle("프리셋 제작")
    }

    private func buildObjectStageView(formable: Formable) -> some View {
        Button {
            viewModel.canvasController.copyFormable(formable)
            guard let preset = formable as? Preset else { return }
            currentPresetId = preset.id
        } label: {
            ObjectStageView(formable: formable)
                .frame(width: 80, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
                .clipped()
        }
    }
}
