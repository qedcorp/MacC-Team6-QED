// Created by byo.

import SwiftUI

struct ObjectCanvasView: UIViewControllerRepresentable {
    let controller: ObjectCanvasViewController

    func makeUIViewController(context: Context) -> ObjectCanvasViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectCanvasViewController, context: Context) {
    }
}

struct ObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = ObjectCanvasViewController()
        return ObjectCanvasView(controller: controller)
    }
}
