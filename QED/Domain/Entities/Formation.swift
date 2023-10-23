// Created by byo.

import Foundation

class Formation: Codable, Formable {

    var members: [Member]
    var startMs: Int?
    var endMs: Int?
    var memo: String?

    init(
        members: [Member] = [],
        startMs: Int? = nil,
        endMs: Int? = nil,
        memo: String? = nil
    ) {
        self.members = members
        self.startMs = startMs
        self.endMs = endMs
        self.memo = memo
    }

    var relativePositions: [RelativePosition] {
        members.map { $0.relativePosition }
    }
}
