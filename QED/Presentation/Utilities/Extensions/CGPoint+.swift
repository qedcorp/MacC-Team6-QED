// Created by byo.

import Foundation

extension CGPoint {
    func getDistance(to point: CGPoint) -> CGFloat {
        let deltaX = point.x - x
        let deltaY = point.y - y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }

    static func getMidPoint(_ lhs: Self, _ rhs: Self) -> Self {
        let midX = (lhs.x + rhs.x) / 2
        let midY = (lhs.y + rhs.y) / 2
        return CGPoint(x: midX, y: midY)
    }
}
