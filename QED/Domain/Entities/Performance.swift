// Created by byo.

import Foundation

class Performance {
    let author: User
    let music: Music
    let headcount: Int
    var title: String?
    var formations: [Formation]
    var transitions: [FormationTransition]
    
    init(
        author: User,
        music: Music,
        headcount: Int,
        title: String? = nil,
        formations: [Formation] = [],
        transitions: [FormationTransition] = []
    ) {
        self.author = author
        self.music = music
        self.headcount = headcount
        self.title = title ?? music.title
        self.formations = formations
        self.transitions = transitions
    }
}
