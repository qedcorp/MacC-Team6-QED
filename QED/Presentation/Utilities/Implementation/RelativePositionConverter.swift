// Created by byo.

import UIKit

class RelativePositionConverter {
    let sizeable: Sizeable

    init(sizeable: Sizeable) {
        self.sizeable = sizeable
    }

    func getRelativePosition(of absolutePosition: CGPoint) -> RelativePosition {
        RelativePosition(
            x: Int(round(absolutePosition.x / sizeable.size.width * CGFloat(RelativePosition.maxX))),
            y: Int(round(absolutePosition.y / sizeable.size.height * CGFloat(RelativePosition.maxY)))
        )
    }

    func getAbsolutePosition(of relativePosition: RelativePosition) -> CGPoint {
        CGPoint(
            x: CGFloat(relativePosition.x) / CGFloat(RelativePosition.maxX) * sizeable.size.width,
            y: CGFloat(relativePosition.y) / CGFloat(RelativePosition.maxY) * sizeable.size.height
        )
    }
}
