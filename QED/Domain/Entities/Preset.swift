// Created by byo.

import Foundation

class Preset: Codable, Formable {
    let headcount: Int
    let relativePositions: [RelativePosition]

    init(headcount: Int, relativePositions: [RelativePosition]) {
        self.headcount = headcount
        self.relativePositions = relativePositions
    }

    var formation: Formation {
        Formation(
            members: relativePositions
                .map { Member(relativePosition: $0) }
        )
    }
}
