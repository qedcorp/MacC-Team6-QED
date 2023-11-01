// Created by byo.

import SwiftUI

struct ObjectInfoAssigningView: UIViewControllerRepresentable {
    let formable: Formable
    let colorHex: String?
    let onChange: (([String?]) -> Void)?
    @State private var controller = ObjectInfoAssigningViewController()

    func makeUIViewController(context: Context) -> ObjectInfoAssigningViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectInfoAssigningViewController, context: Context) {
        uiViewController.colorHex = colorHex
        uiViewController.onChange = onChange
        DispatchQueue.main.async {
            uiViewController.copyFormable(formable)
        }
    }
}
