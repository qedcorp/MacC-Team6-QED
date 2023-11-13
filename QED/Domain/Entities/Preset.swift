// Created by byo.

import Foundation

struct Preset: Codable, Formable {
    let headcount: Int
    let relativePositions: [RelativePosition]
}
