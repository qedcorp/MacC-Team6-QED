// Created by byo.

import Foundation

extension String {
    private static let characters = Set("0123456789ABCDEF")

    static func randomHex() -> String {
        String((0 ..< 6).compactMap { _ in Self.characters.randomElement() })
    }
}
