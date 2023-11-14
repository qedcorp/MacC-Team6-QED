// Created by byo.

import SwiftUI
import UIKit

struct MemberInfoColorset {
    private static let defaultColorHexes = ["8A66F6", "74FB9A", "FDFC54", "F666AB", "FF8000", "FF4601", "FF1594", "FFC700", "01F8FF", "00A5FF", "D9B8FA", "CDFAB8", "F8A98C"]
    private static let hexCharacters = Set("01234567890ABCDEF")

    let colorHexes: [String]

    init(colorHexes: [String] = defaultColorHexes) {
        self.colorHexes = colorHexes
    }
    
    static func getAllColors() -> [String] {
        MemberInfoColorset.defaultColorHexes
    }

    func getColorHex(index: Int) -> String {
        colorHexes[safe: index] ?? Self.getRandomHex()
    }

    private static func getRandomHex() -> String {
        String((0 ..< 6).compactMap { _ in hexCharacters.randomElement() })
    }
}
