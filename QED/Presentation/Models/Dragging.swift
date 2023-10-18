// Created by byo.

import Foundation

struct Dragging {
    let startPosition: CGPoint
    var currentPosition: CGPoint
    var isDragged: Bool = false

    init(startPosition: CGPoint) {
        self.startPosition = startPosition
        self.currentPosition = startPosition
    }

    var positionDiff: CGPoint {
        CGPoint(
            x: currentPosition.x - startPosition.x,
            y: currentPosition.y - startPosition.y
        )
    }
}
