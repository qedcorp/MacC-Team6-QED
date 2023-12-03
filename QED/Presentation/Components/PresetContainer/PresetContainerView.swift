// Created by byo.

import SwiftUI

struct PresetContainerView: View {
    @ObservedObject var viewModel: PresetContainerViewModel
    private let padding: CGFloat = 24
    private let rows: [GridItem] = .init(repeating: .init(.fixed(89)), count: 2)

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 4) {
                    Text("대형")
                    Text("Maker")
                        .foregroundStyle(Color.blueNormal)
                }
                .font(.system(size: 17).weight(.bold))
                .onTapGesture(count: 7) {
                    viewModel.isManaging = true
                }
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
            .frame(height: 54)
            if viewModel.isGridPresented {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHGrid(rows: rows, spacing: 12) {
                        buildObjectStageView(preset: .empty)
                        ForEach(
                            Array(viewModel.presets.sorted { $0.id < $1.id }.enumerated()),
                            id: \.offset
                        ) { _, preset in
                            buildObjectStageView(preset: preset)
                        }
                    }
                    .padding(.horizontal, padding)
                    .padding(.bottom, 14)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isManaging) {
            PresetManagingView()
        }
    }

    private func buildObjectStageView(preset: Preset) -> some View {
        let cornerRadius: CGFloat = 8
        return Button {
            viewModel.canvasController.copyFormable(preset)
        } label: {
            ObjectStageView(formable: preset)
                .aspectRatio(138 / 89, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.build(hex: .memoBackground))
                        .blur(radius: 25)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.strokeGlass3, lineWidth: 1)
                )
                .mask {
                    RoundedRectangle(cornerRadius: cornerRadius)
                }
        }
    }
}
