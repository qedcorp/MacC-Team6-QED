// Created by byo.

import SwiftUI

struct MemberCanvasView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MemberCanvasViewController {
        let controller = MemberCanvasViewController()
        return controller
    }

    func updateUIViewController(_ uiViewController: MemberCanvasViewController, context: Context) {
    }
}

struct MemberCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        MemberCanvasView()
    }
}
