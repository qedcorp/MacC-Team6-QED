// Created by byo.

import SwiftUI
import FirebaseFirestore

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            NavigationView {
                FormationSetupView(
                    performanceUseCase: DefaultPerformanceUseCase(
                        performanceRepository: MockPerformanceRepository(),
                        userStore: DefaultUserStore.shared
                    ),
                    performance: .init(id: "", author: .sample, playable: Music.newJeans, headcount: 5)
                )
            }
        }
    }
}
