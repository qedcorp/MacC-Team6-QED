// swiftlint:disable all
// Created by byo.

import Foundation

struct BezierPath {
    let startPosition: RelativePosition
    let endPosition: RelativePosition
    var controlPoint: ControlPoint? = .buildRandom()

    init(startPosition: RelativePosition, endPosition: RelativePosition) {
        self.startPosition = startPosition
        self.endPosition = endPosition
    }

    struct ControlPoint: Codable, Equatable, RelativeCoordinatable {
        static let maxX = 1000
        static let maxY = 1000

        @MinMax(minValue: 0, maxValue: maxX)
        var x: Int

        @MinMax(minValue: 0, maxValue: maxY)
        var y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }

        static func == (lhs: ControlPoint, rhs: ControlPoint) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y
        }
    }
}
