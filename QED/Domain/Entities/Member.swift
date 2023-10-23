// Created by byo.

import Foundation

class Member: Codable {
    var relativePosition: RelativePosition
    var info: Info?

    init(relativePosition: RelativePosition, info: Info? = nil) {
        self.relativePosition = relativePosition
        self.info = info
    }

    class Info: Hashable, Equatable, Codable {
        var name: String

        @HexString
        var color: String

        init(name: String, color: String) {
            self.name = name
            self.color = color
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        static func == (lhs: Member.Info, rhs: Member.Info) -> Bool {
            lhs === rhs
        }
    }
}
