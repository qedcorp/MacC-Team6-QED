// Created by byo.

import Foundation

class User: Equatable {
    let email: String
    var nickname: String?
    
    init(email: String, nickname: String? = nil) {
        self.email = email
        self.nickname = nickname
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.email == rhs.email
    }
}
