// Created by byo.

import SwiftUI

struct ObjectStageView: UIViewControllerRepresentable {
    let formable: Formable

    func makeUIViewController(context: Context) -> ObjectStageViewController {
        let controller = ObjectStageViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: ObjectStageViewController, context: Context) {
        uiViewController.copyFormable(formable)
    }
}
