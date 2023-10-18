// Created by byo.

import Foundation

struct RelativePosition {
    static let maxX = 100
    static let maxY = 100

    @MinMax(minValue: 0, maxValue: maxX)
    var relativeX: Int

    @MinMax(minValue: 0, maxValue: maxY)
    var relativeY: Int

    // swiftlint:disable:next identifier_name
    init(x: Int, y: Int) {
        self.relativeX = x
        self.relativeY = y
    }
}
