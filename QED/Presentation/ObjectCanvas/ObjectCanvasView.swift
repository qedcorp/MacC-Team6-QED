// Created by byo.

import SwiftUI

struct ObjectCanvasView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ObjectCanvasViewController {
        let controller = ObjectCanvasViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: ObjectCanvasViewController, context: Context) {
    }
}

struct ObjectCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        ObjectCanvasView()
    }
}
