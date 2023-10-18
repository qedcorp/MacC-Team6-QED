// Created by byo.

import UIKit

struct TouchedViewDetector {
    let container: UIView
    let allowedTypes: [UIView.Type]
    let touchPositionConverter: TouchPositionConverter

    func detectView(touch: UITouch) -> UIView? {
        let position = touchPositionConverter.getAbsolutePosition(touch: touch)
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
