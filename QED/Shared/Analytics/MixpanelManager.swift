//
//  MixpanelManager.swift
//  QED
//
//  Created by changgyo seo on 1/15/24.
//

import Mixpanel

struct MixpanelManager {

    static let shared = MixpanelManager()
    private let mixpanel = Mixpanel.mainInstance()
    var me: People {
        mixpanel.people
    }

    private init() {
        Mixpanel.initialize(token: "ab825a0598ae9fcd1ec1db63e594b1d3", trackAutomaticEvents: true)
        Mixpanel.mainInstance().loggingEnabled = true
    }

    func track(_ mixpanelAccount: MixpanelAccounts) {
        switch mixpanelAccount {
        case let .makeProject(properties):
            Mixpanel.mainInstance().track(event: mixpanelAccount.event, properties: properties)
        case let .tabFinishGenerateProjectBtn(properties):
            Mixpanel.mainInstance().track(event: mixpanelAccount.event, properties: properties)
        case let .watchPerformance(properties):
            Mixpanel.mainInstance().track(event: mixpanelAccount.event, properties: properties)
        default:
            Mixpanel.mainInstance().track(event: mixpanelAccount.event, properties: [:])
        }
    }

    func setUp() {
        if let uId = try? KeyChainManager.shared.read(account: .id),
           let mail = try? KeyChainManager.shared.read(account: .email),
           let name = try? KeyChainManager.shared.read(account: .name) {
            Mixpanel.mainInstance().registerSuperProperties(
                [
                    "ID": uId,
                    "EMAIL": mail,
                    "NAME": name
                ]
            )
            Mixpanel.mainInstance().identify(distinctId: uId)
            Mixpanel.mainInstance().people.set(property: "$name", to: uId)
            Mixpanel.mainInstance().people.set(
                properties: [
                    "ID": uId,
                    "EMAIL": mail,
                    "NAME": name
                ]
            )
        }
    }
}
