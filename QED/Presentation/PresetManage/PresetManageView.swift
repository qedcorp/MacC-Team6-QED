// Created by byo.

import SwiftUI

struct PresetManageView: View {
    @StateObject private var viewModel = PresetManageViewModel()

    var body: some View {
        VStack {
            ObjectCanvasView(controller: viewModel.objectCanvasViewController)
                .frame(width: 300, height: 200)
            Button("Generate") {
                viewModel.generatePreset()
            }
            ForEach(Array(viewModel.presets.enumerated()), id: \.offset) { offset, element in
                Button("Preset \(offset)") {
                    viewModel.copyPreset(element)
                }
            }
        }
    }
}

struct PresetManageView_Previews: PreviewProvider {
    static var previews: some View {
        PresetManageView()
    }
}
