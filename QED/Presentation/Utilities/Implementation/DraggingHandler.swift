// Created by byo.

import UIKit

class DraggingHandler: ObservableObject {
    @Published private(set) var dragging: DraggingModel?

    func beginDragging(position: CGPoint) {
        dragging = DraggingModel(startPosition: position)
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
