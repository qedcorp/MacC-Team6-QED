// Created by byo.

import SwiftUI

@main
struct QEDApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            WatchingFormationView(performance: mockPerformance)
        }
    }
}
