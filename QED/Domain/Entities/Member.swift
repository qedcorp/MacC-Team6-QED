// Created by byo.

import Foundation

class Member {
    @MinMax(minValue: MemberConstants.minX, maxValue: MemberConstants.maxX)
    var x: Int
    
    @MinMax(minValue: MemberConstants.minY, maxValue: MemberConstants.maxY)
    var y: Int
    
    var info: Info?
    
    init(x: Int, y: Int, info: Info? = nil) {
        self.x = x
        self.y = y
        self.info = info
    }
    
    class Info: Hashable, Equatable {
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
