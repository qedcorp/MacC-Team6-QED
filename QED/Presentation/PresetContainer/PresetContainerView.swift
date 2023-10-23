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

    private let objectCanvasViewController: ObjectCanvasViewController
    private let headcount: Int?
    private let padding: CGFloat = 22
    private let rows: [GridItem] = .init(repeating: .init(.fixed(80)), count: 2)

    init(objectCanvasViewController: ObjectCanvasViewController, headcount: Int? = nil) {
        self.objectCanvasViewController = objectCanvasViewController
        self.headcount = headcount
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
                            ObjectStageView(formable: preset)
                                .aspectRatio(73 / 48, contentMode: .fit)
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
                    .padding(.horizontal, padding)
                    .padding(.bottom, 12)
                }
            }
        }
        .onAppear {
            viewModel.objectCanvasViewController = objectCanvasViewController
            viewModel.headcount = headcount
            viewModel.fetchPresets()
        }
    }
}
