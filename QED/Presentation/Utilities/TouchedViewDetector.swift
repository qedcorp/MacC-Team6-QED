// Created by byo.

import UIKit

class TouchedViewDetector {
    let container: UIView
    let allowedTypes: [UIView.Type]

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: container)
    }()

    init(container: UIView, allowedTypes: [UIView.Type]) {
        self.container = container
        self.allowedTypes = allowedTypes
    }

    func detectView(position: CGPoint) -> UIView? {
        guard let view = container.hitTest(position, with: nil) else {
            return nil
        }
        if isAllowedType(view: view) {
            return view
        } else {
            return nil
        }
    }

    private func isAllowedType(view: UIView) -> Bool {
        !allowedTypes
            .filter { view.isKind(of: $0) }
            .isEmpty
    }
}
