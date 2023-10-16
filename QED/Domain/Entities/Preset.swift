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
        var x: Int
        
        @MinMax(minValue: MemberConstants.minY, maxValue: MemberConstants.maxY)
        var y: Int
        
        init(x: Int, y: Int) {
            self.x = x
            self.y = y
        }
        
        var member: Member {
            Member(x: x, y: y)
        }
    }
}
