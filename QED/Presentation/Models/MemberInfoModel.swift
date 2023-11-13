// Created by byo.

import Foundation

struct MemberInfoModel: Equatable {
    var color: String
    var name: String

    static func build(entity: Member.Info) -> Self {
        MemberInfoModel(color: entity.color, name: entity.name)
    }
}
