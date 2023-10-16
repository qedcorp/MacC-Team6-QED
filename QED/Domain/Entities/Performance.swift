// Created by byo.

import Foundation

class Performance {
    let author: User
    let playable: Playable
    let headcount: Int
    var title: String?
    var formations: [Formation]
    var transitions: [FormationTransition]
    
    init(
        author: User,
        playable: Playable,
        headcount: Int,
        title: String? = nil,
        formations: [Formation] = [],
        transitions: [FormationTransition] = []
    ) {
        self.author = author
        self.playable = playable
        self.headcount = headcount
        self.title = title ?? playable.title
        self.formations = formations
        self.transitions = transitions
    }
}
