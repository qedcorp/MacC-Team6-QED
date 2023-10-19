// Created by byo.

import SwiftUI

struct PresetManageView: View {
    @StateObject private var viewModel = PresetManageViewModel()

    var body: some View {
        VStack {
            ObjectCanvasView(controller: viewModel.objectCanvasViewController)
                .frame(width: 320, height: 240)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.gray.opacity(0.3))
                )
            Button("Generate") {
                viewModel.generatePreset()
            }
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(viewModel.presets.enumerated()), id: \.offset) { _, preset in
                        ObjectStageView(preset: preset)
                            .frame(width: 80, height: 60)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(.gray.opacity(0.1))
                            )
                            .onTapGesture {
                                viewModel.copyPreset(preset)
                            }
                    }
                }
            }
            .padding()
        }
    }
}

struct PresetManageView_Previews: PreviewProvider {
    static var previews: some View {
        PresetManageView()
    }
}
