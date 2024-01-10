// Created by byo.

import Foundation

final class DefaultUserStore: UserStore {
    static let shared = DefaultUserStore()

    var myUser: User?

    private init() {
        let id = try? KeyChainManager.shared.read(account: .id)
        let email = try? KeyChainManager.shared.read(account: .email)
        let nickname = try? KeyChainManager.shared.read(account: .name)
        let launchingCountString = try? KeyChainManager.shared.read(account: .launchingCount)
        let launchingCount = launchingCountString == nil ? 0 : Int(launchingCountString!)
        
        User(id: id ?? "",
             email: email,
             nickname: nickname,
             isNotificationOn: nil,
             launchingCount: launchingCount
        )
    }
}
