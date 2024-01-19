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
        let launchingCount = launchingCountString == nil ? 0 : Int(launchingCountString!)!

        myUser = User(id: id ?? "",
             email: email,
             nickname: nickname,
             isNotificationOn: nil,
             launchingCount: launchingCount
        )
    }

    @discardableResult
    func increaseLaunchingCount() -> Int {
        guard let myUser = myUser else { return 0 }
        if myUser.launchingCount != nil,
            myUser.launchingCount! >= 0 {
            myUser.launchingCount! += 1
            try? KeyChainManager.shared.delete(account: .launchingCount)
            try? KeyChainManager.shared.create(account: .launchingCount, data: String(myUser.launchingCount ?? 0))
            return myUser.launchingCount!
        } else {
            return myUser.launchingCount!
        }
    }

    func resetLaunchingCount() {
        guard let myUser = myUser else { return }
        myUser.launchingCount = -1
        try? KeyChainManager.shared.delete(account: .launchingCount)
        try? KeyChainManager.shared.create(account: .launchingCount, data: String(myUser.launchingCount ?? 0))
    }
}
