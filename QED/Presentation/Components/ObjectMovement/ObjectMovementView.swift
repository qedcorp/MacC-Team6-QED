// Created by byo.

import SwiftUI

struct ObjectMovementView: UIViewControllerRepresentable {
    let beforeFormation: Formation
    let afterFormation: Formation
    let onChange: (([Member.Info: BezierPath]) -> Void)?
    @State private var controller = ObjectMovementViewController()

    func makeUIViewController(context: Context) -> ObjectMovementViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectMovementViewController, context: Context) {
        DispatchQueue.main.async {
            uiViewController.copy(beforeFormation: beforeFormation, afterFormation: afterFormation)
        }
    }
}
