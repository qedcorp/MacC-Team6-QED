// Created by byo.

import SwiftUI

struct PresetContainerView: View {
    @ObservedObject var viewModel: PresetContainerViewModel
    private let padding: CGFloat = 22
    private let rows: [GridItem] = .init(repeating: .init(.fixed(89)), count: 2)

    var body: some View {
        VStack {
            HStack {
                Text("동선 프리셋")
                    .font(.headline.weight(.bold))
                Spacer()
                Button {
                    viewModel.toggleGrid()
                } label: {
                    Image(systemName: "chevron.\(viewModel.isGridPresented ? "down" : "up")")
                        .font(.title3.weight(.semibold))
                }
            }
            .foregroundStyle(Color.monoWhite3)
            .padding(.horizontal, padding)
            if viewModel.isGridPresented {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows) {
                        buildObjectStageView(preset: .empty)
                        ForEach(Array(viewModel.presets.enumerated()), id: \.offset) { _, preset in
                            buildObjectStageView(preset: preset)
                        }
                    }
                    .padding(.horizontal, padding)
                    .padding(.bottom, 12)
                }
            }
        }
        .onAppear {
            viewModel.fetchPresets()
        }
    }

    private func buildObjectStageView(preset: Preset) -> some View {
        let cornerRadius: CGFloat = 8
        return ObjectStageView(formable: preset)
            .aspectRatio(138 / 89, contentMode: .fit)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.monoNormal2)
                    .blur(radius: 50)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)
            )
            .mask {
                RoundedRectangle(cornerRadius: cornerRadius)
            }
            .onTapGesture {
                viewModel.canvasController.copyFormable(preset)
            }
    }
}
