// Created by byo.

import UIKit

struct TouchPositionConverter {
    let container: UIView

    func getRelativePosition(absolute position: CGPoint) -> RelativePosition {
        RelativePosition(
            x: Int(round(position.x / container.bounds.width * CGFloat(RelativePosition.maxX))),
            y: Int(round(position.y / container.bounds.height * CGFloat(RelativePosition.maxY)))
        )
    }

    func getAbsolutePosition(relative position: RelativePosition) -> CGPoint {
        CGPoint(
            x: CGFloat(position.x) / CGFloat(RelativePosition.maxX) * container.bounds.width,
            y: CGFloat(position.y) / CGFloat(RelativePosition.maxY) * container.bounds.height
        )
    }

    func getAbsolutePosition(touches: Set<UITouch>) -> CGPoint? {
        guard let touch = touches.first else {
            return nil
        }
        return touch.location(in: container)
    }
}
