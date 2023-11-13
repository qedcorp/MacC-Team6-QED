// Created by byo.

import Foundation

struct PerformanceModel: Identifiable, Equatable {
    let entity: Performance
    let music: MusicModel
    let headcount: Int
    let memberInfos: [MemberInfoModel]
    let formations: [FormationModel]

    var id: String {
        entity.id
    }

    static func build(entity: Performance) -> Self {
        PerformanceModel(
            entity: entity,
            music: .build(entity: entity.music),
            headcount: entity.headcount,
            memberInfos: entity.memberInfos?.map { .build(entity: $0) } ?? [],
            formations: entity.formations.map { .build(entity: $0) }
        )
    }
}
