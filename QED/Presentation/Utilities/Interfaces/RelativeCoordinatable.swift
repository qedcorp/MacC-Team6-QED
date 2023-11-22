// swiftlint:disable all
// Created by byo.

import Foundation

protocol RelativeCoordinatable {
    static var maxX: Int { get }
    static var maxY: Int { get }

    var x: Int { get }
    var y: Int { get }

    init(x: Int, y: Int)
}

extension RelativeCoordinatable {
    static func buildRandom() -> Self {
        self.init(
            x: .random(in: 0 ... maxX),
            y: .random(in: 0 ... maxY)
        )
    }
}
