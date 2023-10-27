// Created by byo.

import SwiftUI

struct ObjectStageView: UIViewControllerRepresentable {
    let formable: Formable
    @State private var controller = ObjectStageViewController()

    func makeUIViewController(context: Context) -> ObjectStageViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectStageViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.copyFormable(formable)
        }
    }
}
