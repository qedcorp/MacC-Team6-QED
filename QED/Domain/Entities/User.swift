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
         launchingCount: Int? = nil
    ) {
        self.id = id
        self.email = email
        self.nickname = nickname
        self.isNotificationOn = isNotificationOn
        self.launchingCount = launchingCount == nil ? 0 : launchingCount
    }

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
