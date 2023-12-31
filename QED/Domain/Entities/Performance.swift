// Created by byo.

import Foundation

class Performance: Codable {
    var id: String
    let author: User
    let music: Music
    let headcount: Int
    var createdAt: Date
    var title: String?
    var memberInfos: [Member.Info]?
    var formations: [Formation]

    init(
        id: String,
        author: User,
        music: Music,
        headcount: Int,
        title: String? = nil,
        memberInfos: [Member.Info]? = nil,
        formations: [Formation] = [],
        createdAt: Date? = nil
    ) {
        self.id = id
        self.author = author
        self.music = music
        self.headcount = headcount
        self.title = title ?? music.title
        self.memberInfos = memberInfos ?? Self.buildDefaultMemberInfos(headcount: headcount)
        self.formations = formations
        self.createdAt = createdAt ?? Date()
    }

    private static func buildDefaultMemberInfos(headcount: Int) -> [Member.Info] {
        guard headcount > 0 else {
            return []
        }
        let colorset = MemberInfoColorset()
        return (0 ..< headcount).map {
            Member.Info(
                name: "인물 \($0 + 1)",
                color: colorset.getColorHex(index: $0)
            )
        }
    }

    var isCompleted: Bool {
        !self.formations.isEmpty &&
        self.formations.allSatisfy { !$0.colors.contains(nil) } &&
        self.formations.allSatisfy { $0.members.count == self.headcount }
    }
}

extension Performance: Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Performance, rhs: Performance) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
