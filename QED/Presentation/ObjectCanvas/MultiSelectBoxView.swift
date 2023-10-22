// Created by byo.

import UIKit

class MultiSelectBoxView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStyle() {
        backgroundColor = .green.withAlphaComponent(0.1)
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 1
    }
}
