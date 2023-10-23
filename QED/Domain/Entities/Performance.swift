// Created by byo.

import Foundation

class Performance: Codable {
    let author: User
    // TODO: 이 부분 다 DTO로 만드러서 codable문제 해결하기 ㅠㅠㅠㅠㅠㅠㅠㅠㅠ
    // 이 부분 DTO 다 만들기 뭐해서 일단 이렇게 처리하고 나중에 DTO 만들겠슴다!!!!
    let playable: Music
    let headcount: Int
    var title: String?
    var memberInfos: [Member.Info]
    var formations: [Formation]
    var transitions: [FormationTransition?]

    init(
        author: User,
        playable: Music,
        headcount: Int,
        title: String? = nil,
        formations: [Formation] = [],
        transitions: [FormationTransition?] = []
    ) {
        self.author = author
        self.playable = playable
        self.headcount = headcount
        self.title = title ?? playable.title
        self.memberInfos = (1 ... headcount)
            .map { .init(name: "인물 \($0)", color: .randomHex()) }
        self.formations = formations
        self.transitions = transitions
    }
}
