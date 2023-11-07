// Created by byo.

import UIKit

class GridRenderer {
    private lazy var gridImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "grid")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    func render(in view: UIView) {
        view.addSubview(gridImageView)

        NSLayoutConstraint.activate([
            gridImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gridImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
