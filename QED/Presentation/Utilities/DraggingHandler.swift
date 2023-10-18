// Created by byo.

import UIKit

class DraggingHandler: ObservableObject {
    @Published var dragging: Dragging?

    func beginDragging(position: CGPoint) {
        dragging = Dragging(startPosition: position)
    }

    func moveDragging(position: CGPoint) {
        dragging?.currentPosition = position
        if dragging?.isDragged == false {
            dragging?.isDragged = true
        }
    }

    func endDragging() {
        dragging = nil
    }
}
