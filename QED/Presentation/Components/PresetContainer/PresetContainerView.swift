// Created by byo.

import SwiftUI

struct PresetContainerView: View {
    @StateObject private var viewModel = PresetContainerViewModel(
        presetUseCase: DefaultPresetUseCase(
            presetRepository: DefaultPresetRepository(
                remoteManager: FireStoreManager()
            )
        )
    )

    private let headcount: Int
    private let objectCanvasViewController: ObjectCanvasViewController
    private let padding: CGFloat = 22
    private let rows: [GridItem] = .init(repeating: .init(.fixed(80)), count: 2)

    init(headcount: Int, objectCanvasViewController: ObjectCanvasViewController) {
        self.headcount = headcount
        self.objectCanvasViewController = objectCanvasViewController
    }

    var body: some View {
        VStack {
            HStack {
                Text("동선 프리셋")
                    .font(.headline)
                Spacer()
                Button("Toggle") {
                    withAnimation {
                        viewModel.isGridPresented.toggle()
                    }
                }
            }
            .padding(.horizontal, padding)
            if viewModel.isGridPresented {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows) {
                        buildObjectStageView(formable: Preset.empty)
                        ForEach(Array(viewModel.presets.enumerated()), id: \.offset) { _, preset in
                            buildObjectStageView(formable: preset)
                        }
                    }
                    .padding(.horizontal, padding)
                    .padding(.bottom, 12)
                }
            }
        }
        .onAppear {
            viewModel.headcount = headcount // TODO: @StateObject의 경우 초기값을 어떻게 넣어야 할까
            viewModel.fetchPresets()
        }
    }

    private func buildObjectStageView(formable: Formable) -> some View {
        ObjectStageView(formable: formable)
            .aspectRatio(73 / 48, contentMode: .fit)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.1))
            )
            .clipped()
            .onTapGesture {
                objectCanvasViewController.copyFormable(formable)
            }
    }
}
