// Created by byo.

import Foundation

class Preset {
    let headcount: Int
    let members: [PresetMember]

    init(headcount: Int, members: [PresetMember]) {
        self.headcount = headcount
        self.members = members
    }

    var formation: Formation {
        Formation(
            members: members
                .map { $0.member }
        )
    }

    struct PresetMember {
        @MinMax(minValue: MemberConstants.minX, maxValue: MemberConstants.maxX)
        var relativeX: Int

        @MinMax(minValue: MemberConstants.minY, maxValue: MemberConstants.maxY)
        var relativeY: Int

        init(relativeX: Int, relativeY: Int) {
            self.relativeX = relativeX
            self.relativeY = relativeY
        }

        var member: Member {
            Member(relativeX: relativeX, relativeY: relativeY)
        }
    }
}
