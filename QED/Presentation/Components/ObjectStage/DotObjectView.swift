// Created by byo.

import UIKit

class DotObjectView: UIView {
    var radius: CGFloat? {
        didSet {
            guard let radius = radius else {
                return
            }
            frame.size = .init(width: radius * 2, height: radius * 2)
            layer.cornerRadius = radius
        }
    }

    var color: UIColor? {
        didSet {
            backgroundColor = color
        }
    }

    private var lastCenter: CGPoint?

    init() {
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func assignPosition(_ position: CGPoint) {
        center = position
        lastCenter = position
    }

    func assignPositionDiff(_ diff: CGPoint) {
        guard let last = lastCenter else {
            return
        }
        center = .init(
            x: last.x + diff.x,
            y: last.y + diff.y
        )
    }
}
