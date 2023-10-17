// Created by byo.

import Foundation

final class DefaultUserStore: UserStore {
    static let shared = DefaultUserStore()
    
    var me: User?
    
    private init() {
    }
}
