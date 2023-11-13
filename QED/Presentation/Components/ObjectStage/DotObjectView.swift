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
            borderLayer.frame = bounds.insetBy(dx: -borderLayer.borderWidth, dy: -borderLayer.borderWidth)
            borderLayer.cornerRadius = radius + borderLayer.borderWidth
        }
    }

    var color: UIColor? {
        didSet { backgroundColor = color }
    }

    var borderColor: UIColor? {
        didSet { borderLayer.borderColor = (borderColor ?? .clear).cgColor }
    }

    private var lastCenter: CGPoint?

    private lazy var borderLayer = {
        let border = CALayer()
        border.borderWidth = 2.5
        border.borderColor = UIColor.clear.cgColor
        layer.addSublayer(border)
        return border
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
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
