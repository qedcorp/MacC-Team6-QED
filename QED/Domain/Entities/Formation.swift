// Created by byo.

import Foundation

class Formation: Codable, Formable, ColorArrayable {
    var members: [Member]
    var movementMap: MovementMap?
    var startMs: Int?
    var endMs: Int?
    var memo: String?
    var note: String?

    init(
        members: [Member] = [],
        movementMap: MovementMap? = nil,
        startMs: Int? = nil,
        endMs: Int? = nil,
        memo: String? = nil,
        note: String? = ""
    ) {
        self.members = members
        self.movementMap = movementMap
        self.startMs = startMs
        self.endMs = endMs
        self.memo = memo
        self.note = note
    }

    var relativePositions: [RelativePosition] {
        members.map { $0.relativePosition }
    }

    var colors: [String?] {
        members.map { $0.info?.color }
    }
}
