// Created by byo.

import SwiftUI

struct PresetManagingView: View {
    @StateObject private var viewModel = PresetManagingViewModel()

    var body: some View {
        VStack {
            VStack {
                Slider(
                    value: .init(
                        get: { Double(viewModel.headcount) },
                        set: { viewModel.headcount = Int($0) }
                    ),
                    in: 2 ... 13
                )

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
                    Spacer()
                    Button("Generate") {
                        viewModel.createPreset()
                    }
                }
            }
            .frame(width: 320)
            ScrollView(.horizontal) {
                HStack {
                    buildObjectStageView(formable: Preset.empty)
                    ForEach(Array(viewModel.presets.enumerated()), id: \.offset) { _, preset in
                        buildObjectStageView(formable: preset)
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
        ObjectStageView(formable: formable)
            .frame(width: 80, height: 60)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.1))
            )
            .clipped()
            .onTapGesture {
                viewModel.canvasController.copyFormable(formable)
            }
    }
}
