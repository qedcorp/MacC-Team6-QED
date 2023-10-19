// Created by byo.

import SwiftUI

struct ObjectStageView: UIViewControllerRepresentable {
    let preset: Preset

    func makeUIViewController(context: Context) -> ObjectStageViewController {
        let controller = ObjectStageViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: ObjectStageViewController, context: Context) {
        uiViewController.copyPreset(preset)
    }
}

struct ObjectStageView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectStageView(preset: .init(headcount: 0, relativePositions: []))
    }
}
