// Created by byo.

import SwiftUI

struct ObjectCanvasView: UIViewControllerRepresentable {
    private let controller: ObjectCanvasViewController
    private let headcount: Int?

    init(controller: ObjectCanvasViewController, headcount: Int? = nil) {
        self.controller = controller
        self.headcount = headcount
    }

    func makeUIViewController(context: Context) -> ObjectCanvasViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectCanvasViewController, context: Context) {
        uiViewController.maxObjectsCount = headcount
    }
}
