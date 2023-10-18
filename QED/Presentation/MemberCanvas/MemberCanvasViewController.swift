// Created by byo.

import UIKit

class MemberCanvasViewController: UIViewController {
    override func loadView() {
        super.loadView()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .lightGray
        setupCenterLines()
    }

    private func setupCenterLines() {
        let renderer = CenterLinesRenderer(color: .green)
        renderer.render(in: view)
    }
}
