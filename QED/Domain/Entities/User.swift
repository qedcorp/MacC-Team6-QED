// Created by byo.

import Foundation

class User: Equatable, Codable {
    var id: String
    var email: String?
    var nickname: String?
    var isNotificationOn: Bool?
    var launchingCount: Int?

    init(id: String = "",
         email: String? = nil,
         nickname: String? = nil,
         isNotificationOn: Bool? = nil,
         launchingCount: Int = 0
    ) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.isNotificationOn = isNotificationOn
        self.launchingCount = launchingCount
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
