// Created by byo.

import Foundation

final class DefaultUserStore: UserStore {
    static let shared = DefaultUserStore()

    var myUser: User?

    private init() {

    }
}
