// Created by byo.

import SwiftUI
import UIKit

struct MemberInfoColorset {
    private static let defaultColorHexes = ["5E5CE6", "74FB9A", "FDFC54", "F666AB", "D9B8FA", "CDFAB8"]
    private static let hexCharacters = Set("01234567890ABCDEF")

    let colorHexes: [String]

    init(colorHexes: [String] = defaultColorHexes) {
        self.colorHexes = colorHexes
    }

    func getColorHex(index: Int) -> String {
        colorHexes[safe: index] ?? Self.getRandomHex()
    }

    private static func getRandomHex() -> String {
        String((0 ..< 6).compactMap { _ in hexCharacters.randomElement() })
    }
}
