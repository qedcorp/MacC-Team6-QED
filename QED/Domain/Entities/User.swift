// Created by byo.

import Foundation

class User: Equatable, Codable {
    var id: String
    var email: String?
    var nickname: String?
    var isNotificationOn: Bool?

    init(id: String = "", email: String? = nil, nickname: String? = nil, isNotificationOn: Bool? = nil) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.isNotificationOn = isNotificationOn
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
