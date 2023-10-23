// Created by byo.

import Foundation

struct FormationModel: Equatable, Formable, ColorArrayable {
    var memo: String?
    var members: [MemberModel]

    init(memo: String? = nil, members: [MemberModel] = []) {
        self.memo = memo
        self.members = members
    }

    var relativePositions: [RelativePosition] {
        members.map { $0.relativePosition }
    }

    var colors: [String?] {
        members.map { $0.color }
    }

    func buildEntity() -> Formation {
        Formation(
            members: members.map { $0.buildEntity() },
            memo: memo
        )
    }

    static func build(entity: Formation) -> Self {
        FormationModel(
            memo: entity.memo,
            members: entity.members.map { .build(entity: $0) }
        )
    }
}
