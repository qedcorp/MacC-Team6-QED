// Created by byo.

import Foundation

extension CGRect {
    func contains(point: CGPoint) -> Bool {
        point.x >= origin.x &&
        point.x <= origin.x + size.width &&
        point.y >= origin.y &&
        point.y <= origin.y + size.height
    }
}
