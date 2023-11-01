// Created by byo.

import SwiftUI

struct ObjectMovementView: UIViewControllerRepresentable {
    let beforeFormation: Formation
    let afterFormation: Formation
    let onChange: ((MovementMap) -> Void)?
    @State private var controller = ObjectMovementViewController()

    func makeUIViewController(context: Context) -> ObjectMovementViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectMovementViewController, context: Context) {
        uiViewController.onChange = onChange
        DispatchQueue.main.async {
            uiViewController.copy(beforeFormation: beforeFormation, afterFormation: afterFormation)
        }
    }
}
