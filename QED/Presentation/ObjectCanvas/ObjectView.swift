// Created by byo.

import UIKit

class ObjectView: UIView {
    var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }

    private var lastPosition: CGPoint?

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

    func refreshLastPosition() {
        lastPosition = frame.origin
    }

    func applyPositionDiff(_ diff: CGPoint) {
        guard let last = lastPosition else {
            return
        }
        frame.origin = .init(
            x: last.x + diff.x,
            y: last.y + diff.y
        )
    }
}
