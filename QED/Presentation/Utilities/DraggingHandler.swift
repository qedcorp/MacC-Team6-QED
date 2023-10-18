// Created by byo.

import UIKit

class DraggingHandler: ObservableObject {
    let touchPositionConverter: TouchPositionConverter
    @Published var dragging: Dragging?

    init(touchPositionConverter: TouchPositionConverter) {
        self.touchPositionConverter = touchPositionConverter
    }

    func beginDragging(touch: UITouch) {
        let position = touchPositionConverter.getAbsolutePosition(touch: touch)
        dragging = Dragging(startPosition: position)
    }

    func moveDragging(touch: UITouch) {
        let position = touchPositionConverter.getAbsolutePosition(touch: touch)
        dragging?.currentPosition = position
        if dragging?.isDragged == false {
            dragging?.isDragged = true
        }
    }

    func endDragging() {
        dragging = nil
    }
}
