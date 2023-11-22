// Created by byo.

import Foundation

struct Preset: Codable, Formable {
    var id: String
    let headcount: Int
    let relativePositions: [RelativePosition]
}

extension Preset {
    static var presetID = 1
}
