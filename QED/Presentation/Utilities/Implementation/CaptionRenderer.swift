// Created by byo.

import UIKit

class CaptionRenderer {
    let text: String

    private lazy var captionLabel = {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 7, weight: .semibold)
        label.textColor = .monoWhite3
        label.layer.zPosition = 100
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(text: String) {
        self.text = text
    }

    func render(in view: UIView) {
        view.addSubview(captionLabel)

        NSLayoutConstraint.activate([
            captionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4)
        ])
    }
}
