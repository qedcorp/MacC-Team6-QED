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

    func buildEntity(memberInfos: [Member.Info]) -> Formation {
        Formation(
            members: members
                .map { model in
                    Member(
                        relativePosition: model.relativePosition,
                        info: memberInfos.first(where: { $0.color == model.color })
                    )
                },
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
