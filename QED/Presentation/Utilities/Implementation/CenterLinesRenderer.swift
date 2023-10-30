// Created by byo.

import UIKit

class CenterLinesRenderer {
    let color: UIColor

    private lazy var verticalLine = {
        Self.buildLine(color: color)
    }()

    private lazy var horizontalLine = {
        Self.buildLine(color: color)
    }()

    init(color: UIColor) {
        self.color = color
    }

    func render(in view: UIView) {
        view.addSubview(verticalLine)
        view.addSubview(horizontalLine)

        NSLayoutConstraint.activate([
            verticalLine.widthAnchor.constraint(equalToConstant: 1),
            verticalLine.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verticalLine.topAnchor.constraint(equalTo: view.topAnchor),
            verticalLine.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            horizontalLine.heightAnchor.constraint(equalToConstant: 1),
            horizontalLine.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            horizontalLine.leftAnchor.constraint(equalTo: view.leftAnchor),
            horizontalLine.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private static func buildLine(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
