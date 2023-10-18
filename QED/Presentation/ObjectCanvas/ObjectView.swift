// Created by byo.

import UIKit

class ObjectView: UIView {
    var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }

    init(color: UIColor = .black) {
        self.color = color
        super.init(frame: .zero)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        let radius: CGFloat = 8
        frame.size = .init(width: radius * 2, height: radius * 2)
        backgroundColor = color
        layer.cornerRadius = radius
    }
}
