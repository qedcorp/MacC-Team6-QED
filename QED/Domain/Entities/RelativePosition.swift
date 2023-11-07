// swiftlint:disable all
// Created by byo.

import Foundation


struct RelativePosition: Codable, Equatable, RelativeCoordinatable {
    static let maxX = 38
    static let maxY = 24
    
    @MinMax(minValue: 1, maxValue: maxX - 1)
    var x: Int
    
    @MinMax(minValue: 1, maxValue: maxY - 1)
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func == (lhs: RelativePosition, rhs: RelativePosition) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

