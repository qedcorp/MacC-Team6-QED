// Created by byo.

import SwiftUI

struct ObjectCanvasView: UIViewControllerRepresentable {
    let controller: ObjectCanvasViewController
    let headcount: Int
    let onChange: (([CGPoint]) -> Void)?

    func makeUIViewController(context: Context) -> ObjectCanvasViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectCanvasViewController, context: Context) {
        uiViewController.maxObjectsCount = headcount
        uiViewController.onChange = onChange
    }
}
