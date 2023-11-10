// Created by byo.

import UIKit

class MultiSelectBoxView: UIView {
    override var frame: CGRect {
        didSet { layer.cornerRadius = min(min(size.width, size.height) / 2, 10) }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .blueLight1
        layer.borderColor = UIColor.blueLight3.cgColor
        layer.borderWidth = 1
    }
}
