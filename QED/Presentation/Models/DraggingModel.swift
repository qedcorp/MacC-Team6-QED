// Created by byo.

import Foundation

struct DraggingModel {
    let startPosition: CGPoint
    var currentPosition: CGPoint
    var isDragged: Bool = false

    init(startPosition: CGPoint) {
        self.startPosition = startPosition
        self.currentPosition = startPosition
    }

    var rect: CGRect {
        CGRect(
            origin: startPosition,
            size: .init(
                width: currentPosition.x - startPosition.x,
                height: currentPosition.y - startPosition.y
            )
        )
    }

    var positionDiff: CGPoint {
        CGPoint(
            x: currentPosition.x - startPosition.x,
            y: currentPosition.y - startPosition.y
        )
    }
}
