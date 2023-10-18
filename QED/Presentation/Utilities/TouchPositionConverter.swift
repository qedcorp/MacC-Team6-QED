// Created by byo.

import UIKit

struct TouchPositionConverter {
    let container: UIView

    func getRelativePosition(touch: UITouch) -> (Float, Float) {
        let position = getAbsolutePosition(touch: touch)
        return (
            Float(position.x / container.bounds.width),
            Float(position.y / container.bounds.height)
        )
    }

    func getAbsolutePosition(touch: UITouch) -> CGPoint {
        touch.location(in: container)
    }
}
