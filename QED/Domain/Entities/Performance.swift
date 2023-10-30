// Created by byo.

import Foundation

class Performance: Codable {
    var id: String
    let author: User
    // TODO: 이 부분 다 DTO로 만드러서 codable문제 해결하기 ㅠㅠㅠㅠㅠㅠㅠㅠㅠ
    // 이 부분 DTO 다 만들기 뭐해서 일단 이렇게 처리하고 나중에 DTO 만들겠슴다!!!!
    let music: Music
    let headcount: Int
    var title: String?
    var memberInfos: [Member.Info]
    var formations: [Formation]
    var transitions: [FormationTransition?]

    init(
        id: String,
        author: User,
        music: Music,
        headcount: Int,
        title: String? = nil,
        formations: [Formation] = [],
        transitions: [FormationTransition?] = []
    ) {
        self.id = id
        self.author = author
        self.music = music
        self.headcount = headcount
        self.title = title ?? music.title
        self.memberInfos = Self.buildDefaultMemberInfos(headcount: headcount)
        self.formations = formations
        self.transitions = transitions
    }

    private static func buildDefaultMemberInfos(headcount: Int) -> [Member.Info] {
        guard headcount > 0 else {
            return []
        }
        return (1 ... headcount)
            .map { .init(name: "인물 \($0)", color: .randomHex()) }
    }
}
