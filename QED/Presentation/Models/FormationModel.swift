// Created by byo.

import Foundation

struct FormationModel: Equatable, Formable, ColorArrayable {
    let entity: Formation
    var memo: String?
    var members: [MemberModel]
    var movementMap: MovementMap?

    init(entity: Formation, memo: String? = nil, members: [MemberModel] = [], movementMap: MovementMap? = nil) {
        self.entity = entity
        self.memo = memo
        self.members = members
        self.movementMap = movementMap
    }

    var relativePositions: [RelativePosition] {
        members.map { $0.relativePosition }
    }

    var colors: [String?] {
        members.map { $0.color }
    }

    static func build(entity: Formation) -> Self {
        FormationModel(
            entity: entity,
            memo: entity.memo,
            members: entity.members.map { .build(entity: $0) },
            movementMap: entity.movementMap
        )
    }
}
