// Created by byo.

import SwiftUI

struct PresetContainerView: View {
    @ObservedObject private var viewModel: PresetContainerViewModel
    private let objectCanvasViewController: ObjectCanvasViewController
    private let padding: CGFloat = 22
    private let rows: [GridItem] = .init(repeating: .init(.fixed(82)), count: 2)

    init(
        presetUseCase: PresetUseCase,
        objectCanvasViewController: ObjectCanvasViewController
    ) {
        self.viewModel = PresetContainerViewModel(presetUseCase: presetUseCase)
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
                        ForEach(Array(viewModel.getPresets().enumerated()), id: \.offset) { _, preset in
                            ObjectStageView(preset: preset)
                                .aspectRatio(73 / 48, contentMode: .fit)
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
                    .padding(.horizontal, padding)
                    .padding(.bottom, 12)
                }
            }
        }
        .onAppear {
            viewModel.objectCanvasViewController = objectCanvasViewController
            viewModel.fetchPresets()
        }
    }
}

struct PresetContainerView_Previews: PreviewProvider {
    static var previews: some View {
        let presetUseCase = DefaultPresetUseCase(
            presetRepository: MockPresetRepository()
        )
        let objectCanvasViewController = ObjectCanvasViewController()
        return PresetContainerView(
            presetUseCase: presetUseCase,
            objectCanvasViewController: objectCanvasViewController
        )
    }
}
