// Created by byo.

import SwiftUI
import FirebaseFirestore

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isLogin = false

    var body: some Scene {
        WindowGroup {
            if isLogin || (try? KeyChainManager.shared.read(account: .id)) != nil {
                NavigationView {
                    NavigationLink("홈") {
                        FormationSettingView(
                            performance: Performance(id: "", author: .sample, music: .newJeans, headcount: 5),
                            performanceUseCase: DefaultPerformanceUseCase(
                                performanceRepository: MockPerformanceRepository(),
                                userStore: DefaultUserStore.shared
                            )
                        )
                    }
                }
                .tint(.blueLight3)
            } else {
                AuthView(loginViewModel: LoginViewModel(isLogin: $isLogin))
            }
        }
    }
}
