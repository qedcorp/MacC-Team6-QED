// Created by byo.

import Foundation

class User: Equatable, Codable {
    var id: String
    var email: String?
    var nickname: String?

    init(id: String = "", email: String? = nil, nickname: String? = nil) {
        self.id = id
        self.email = email
        self.nickname = nickname
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
