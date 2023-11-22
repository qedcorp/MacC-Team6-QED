// Created by byo.

import SwiftUI

struct ObjectStageView: UIViewControllerRepresentable {
    let formable: Formable
    let isColorAssignable: Bool
    @State private var controller = ObjectStageViewController()

    init(formable: Formable, isColorAssignable: Bool = false) {
        self.formable = formable
        self.isColorAssignable = isColorAssignable
    }

    func makeUIViewController(context: Context) -> ObjectStageViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectStageViewController, context: Context) {
        uiViewController.isColorAssignable = isColorAssignable
        DispatchQueue.main.async {
            uiViewController.copyFormable(formable)
        }
    }
}
