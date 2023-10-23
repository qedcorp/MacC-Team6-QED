// Created by byo.

import SwiftUI

struct ObjectSelectionView: UIViewControllerRepresentable {
    let controller: ObjectSelectionViewController

    func makeUIViewController(context: Context) -> ObjectSelectionViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectSelectionViewController, context: Context) {
    }
}
