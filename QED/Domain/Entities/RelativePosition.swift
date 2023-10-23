// swiftlint:disable all
// Created by byo.

import Foundation

struct RelativePosition: Codable, Equatable {
    static let maxX = 16
    static let maxY = 10
    
    @MinMax(minValue: 0, maxValue: maxX)
    var x: Int
    
    @MinMax(minValue: 0, maxValue: maxY)
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    static func == (lhs: RelativePosition, rhs: RelativePosition) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}
