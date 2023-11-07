// Created by byo.

import Foundation

extension CGPoint {
    func getDistance(to point: CGPoint) -> CGFloat {
        let deltaX = point.x - x
        let deltaY = point.y - y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
}
