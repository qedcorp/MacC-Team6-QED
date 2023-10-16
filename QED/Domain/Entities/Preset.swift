// Created by byo.

import Foundation

class Preset {
    let headcount: Int
    let members: [(x: Int, y: Int)]
    
    init(headcount: Int, members: [(x: Int, y: Int)]) {
        self.headcount = headcount
        self.members = members
    }
    
    var formation: Formation {
        Formation(
            members: members
                .map { Member(x: $0.x, y: $0.y) }
        )
    }
}
