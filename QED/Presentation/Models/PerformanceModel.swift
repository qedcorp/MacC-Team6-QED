// Created by byo.

import Foundation

struct PerformanceModel: Identifiable, Equatable {
    let entity: Performance
    let title: String?
    let music: MusicModel
    let headcount: Int
    let memberInfos: [MemberInfoModel]
    let formations: [FormationModel]
    let isCompleted: Bool
    let createdAt: Date

    var id: String {
        entity.id
    }

    static func build(entity: Performance) -> Self {
        PerformanceModel(
            entity: entity,
            title: entity.title,
            music: .build(entity: entity.music),
            headcount: entity.headcount,
            memberInfos: entity.memberInfos?.map { .build(entity: $0) } ?? [],
            formations: entity.formations.map { .build(entity: $0) },
            isCompleted: entity.isCompleted,
            createdAt: entity.createdAt
        )
    }
}
