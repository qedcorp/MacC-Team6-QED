// Created by byo.

import SwiftUI
import FirebaseFirestore

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            FormationSettingView(
                performance: .init(id: "", author: .sample, music: Music.newJeans, headcount: 5),
                performanceUseCase: DefaultPerformanceUseCase(
                    performanceRepository: MockPerformanceRepository(),
                    userStore: DefaultUserStore.shared
                )
            )
        }
    }
}
