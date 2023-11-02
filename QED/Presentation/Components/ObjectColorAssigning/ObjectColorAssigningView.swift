// Created by byo.

import SwiftUI

struct ObjectColorAssigningView: UIViewControllerRepresentable {
    let formable: Formable
    let colorHex: String?
    let onChange: (([String?]) -> Void)?
    @State private var controller = ObjectColorAssigningViewController()

    func makeUIViewController(context: Context) -> ObjectColorAssigningViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectColorAssigningViewController, context: Context) {
        uiViewController.colorHex = colorHex
        uiViewController.onChange = onChange
        DispatchQueue.main.async {
            uiViewController.copyFormable(formable)
        }
    }
}
