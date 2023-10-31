// Created by byo.

import UIKit

class RelativeCoordinateConverter {
    let sizeable: Sizeable

    init(sizeable: Sizeable) {
        self.sizeable = sizeable
    }

    func getRelativeValue<T: RelativeCoordinatable>(of absoluteValue: CGPoint, type: T.Type) -> T {
        T(
            x: Int(round(absoluteValue.x / sizeable.size.width * CGFloat(T.maxX))),
            y: Int(round(absoluteValue.y / sizeable.size.height * CGFloat(T.maxY)))
        )
    }

    func getAbsoluteValue<T: RelativeCoordinatable>(of relativeValue: T) -> CGPoint {
        CGPoint(
            x: CGFloat(relativeValue.x) / CGFloat(T.maxX) * sizeable.size.width,
            y: CGFloat(relativeValue.y) / CGFloat(T.maxY) * sizeable.size.height
        )
    }
}
