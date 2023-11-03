// swiftlint:disable all
//  DeletePreset.swift
//  QED
//
//  Created by changgyo seo on 11/3/23.
//

import SwiftUI

struct DeletePresetView: View {

    var useCase = DefaultPresetUseCase(presetRepository: DefaultPresetRepository(remoteManager: FireStoreManager()))
    @State var presets: [Preset] = []

    var body: some View {
        ScrollView(.vertical) {
            ForEach(presets) { preset in
                cell(preset)
            }
        }
        .task {
            presets = try! await useCase.getPresets(headcount: 5)
            for preset in presets {
                print(preset.jsonString)
                print("---------------------------")
            }
        }
    }

    func cell(_ preset: Preset) -> some View {
        ObjectStageView(formable: preset.formation)
            .frame(width: 200, height: 100)
    }
}

extension Preset: Identifiable {
    var id: String { UUID().uuidString }
}
