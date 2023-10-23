// Created by byo.

import Foundation

struct MemberModel: Equatable {
    var relativePosition: RelativePosition
    var name: String?
    var color: String?

    func buildEntity() -> Member {
        Member(
            relativePosition: relativePosition,
            info: .init(
                name: name ?? "",
                color: color ?? ""
            )
        )
    }

    static func build(entity: Member) -> Self {
        MemberModel(
            relativePosition: entity.relativePosition,
            name: entity.info?.name,
            color: entity.info?.color
        )
    }
}
