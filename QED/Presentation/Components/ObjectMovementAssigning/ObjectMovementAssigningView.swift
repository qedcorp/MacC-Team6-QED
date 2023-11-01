// Created by byo.

import SwiftUI

struct ObjectMovementAssigningView: UIViewControllerRepresentable {
    let controller: ObjectMovementAssigningViewController
    let beforeFormation: Formation
    let afterFormation: Formation
    let onChange: ((MovementMap) -> Void)?

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
