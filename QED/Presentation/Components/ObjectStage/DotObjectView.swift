// Created by byo.

import UIKit

import SnapKit

class DotObjectView: UIView {
    var radius: CGFloat? {
        didSet { updateRadius() }
    }

    var color: UIColor? {
        didSet { backgroundColor = color }
    }

    var borderColor: UIColor? {
        didSet { borderLayer.borderColor = (borderColor ?? .clear).cgColor }
    }

    var borderWidth: CGFloat? {
        didSet {
            borderLayer.borderWidth = borderWidth ?? 0
            updateRadius()
        }
    }

    var name: String? {
        didSet { nameLabel.text = name ?? "" }
    }

    private var lastCenter: CGPoint?

    private lazy var nameLabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 6)
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        return label
    }()

    private lazy var borderLayer = {
        let border = CALayer()
        border.borderColor = UIColor.clear.cgColor
        border.borderWidth = 0
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

    private func updateRadius() {
        guard let radius = radius else {
            return
        }
        frame.size = .init(width: radius * 2, height: radius * 2)
        layer.cornerRadius = radius
        borderLayer.frame = bounds.insetBy(dx: -borderLayer.borderWidth, dy: -borderLayer.borderWidth)
        borderLayer.cornerRadius = radius + borderLayer.borderWidth
    }
}
