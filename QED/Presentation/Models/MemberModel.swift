// Created by byo.

import Foundation

struct MemberModel: Equatable {

    var relativePosition: RelativePosition
    var name: String?
    var color: String?

    static func == (lhs: MemberModel, rhs: MemberModel) -> Bool {
        lhs.relativePosition == rhs.relativePosition
    }

    static func build(entity: Member) -> Self {
        MemberModel(
            relativePosition: entity.relativePosition,
            name: entity.info?.name,
            color: entity.info?.color
        )
    }
}