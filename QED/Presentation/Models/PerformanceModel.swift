// Created by byo.

import Foundation

struct PerformanceModel: Equatable {
    let music: MusicModel
    let headcount: Int
    let memberInfos: [MemberInfoModel]
    let formations: [FormationModel]

    static func build(entity: Performance) -> Self {
        PerformanceModel(
            music: .build(entity: entity.music),
            headcount: entity.headcount,
            memberInfos: entity.memberInfos.map { .build(entity: $0) },
            formations: entity.formations.map { .build(entity: $0) }
        )
    }
}
