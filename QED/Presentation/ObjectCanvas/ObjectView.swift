// Created by byo.

import UIKit

class ObjectView: UIView {
    static let radius: CGFloat = 8

    var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }

    private var lastCenter: CGPoint?

    init(color: UIColor = .black) {
        self.color = color
        super.init(frame: .zero)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        frame.size = .init(width: Self.radius * 2, height: Self.radius * 2)
        backgroundColor = color
        layer.cornerRadius = Self.radius
    }

    func applyPosition(_ position: CGPoint) {
        center = position
        lastCenter = position
    }

    func applyPositionDiff(_ diff: CGPoint) {
        guard let last = lastCenter else {
            return
        }
        center = .init(
            x: last.x + diff.x + Self.radius,
            y: last.y + diff.y + Self.radius
        )
    }
}
