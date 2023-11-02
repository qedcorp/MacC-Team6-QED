// Created by byo.

import SwiftUI

struct ObjectCanvasView: UIViewControllerRepresentable {
    let controller: ObjectCanvasViewController
    let formable: Formable?
    let headcount: Int
    let onChange: (([CGPoint]) -> Void)?

    func makeUIViewController(context: Context) -> ObjectCanvasViewController {
        controller.isColorAssignable = false
        return controller
    }

    func updateUIViewController(_ uiViewController: ObjectCanvasViewController, context: Context) {
        uiViewController.maxObjectsCount = headcount
        uiViewController.onChange = onChange
        DispatchQueue.main.async {
            uiViewController.copyFormable(formable)
        }
    }
}
