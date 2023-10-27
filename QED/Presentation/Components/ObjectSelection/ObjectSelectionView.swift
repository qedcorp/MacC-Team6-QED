// Created by byo.

import SwiftUI

struct ObjectSelectionView: UIViewControllerRepresentable {
    let formable: Formable
    let colorHex: String?
    let onChange: (([String?]) -> Void)?
    @State private var controller = ObjectSelectionViewController()

    func makeUIViewController(context: Context) -> ObjectSelectionViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectSelectionViewController, context: Context) {
        uiViewController.colorHex = colorHex
        uiViewController.onChange = onChange
        DispatchQueue.main.async {
            uiViewController.copyFormable(formable)
        }
    }
}
