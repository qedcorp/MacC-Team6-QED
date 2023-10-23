// Created by byo.

import Foundation

struct MemberInfoModel: Equatable {
    var color: String
    var name: String

    func buildEntity() -> Member.Info {
        Member.Info(name: name, color: color)
    }

    static func build(entity: Member.Info) -> Self {
        MemberInfoModel(color: entity.color, name: entity.name)
    }
}
