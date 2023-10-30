// Created by byo.

import Foundation

class Formation: Codable, Formable {

    var members: [Member]
    var startMs: Int?
    var endMs: Int?
    var memo: String?
    var note: String?

    init(
        members: [Member] = [],
        startMs: Int? = nil,
        endMs: Int? = nil,
        memo: String? = nil,
        note: String? = ""
    ) {
        self.members = members
        self.startMs = startMs
        self.endMs = endMs
        self.memo = memo
        self.note = note
    }

    var relativePositions: [RelativePosition] {
        members.map { $0.relativePosition }
    }
}
