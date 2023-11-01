// Created by byo.

import SwiftUI

struct ObjectMovementAssigningView: UIViewControllerRepresentable {
    let beforeFormation: Formation
    let afterFormation: Formation
    let onChange: ((MovementMap) -> Void)?
    @State private var controller = ObjectMovementAssigningViewController()

    func makeUIViewController(context: Context) -> ObjectMovementAssigningViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectMovementAssigningViewController, context: Context) {
        uiViewController.onChange = onChange
        DispatchQueue.main.async {
            uiViewController.copy(beforeFormation: beforeFormation, afterFormation: afterFormation)
        }
    }
}
