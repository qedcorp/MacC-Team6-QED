// Created by byo.

import UIKit

struct TouchPositionConverter {
    let container: UIView

    func getPosition(touches: Set<UITouch>) -> CGPoint? {
        guard let touch = touches.first else {
            return nil
        }
        return touch.location(in: container)
    }
}
