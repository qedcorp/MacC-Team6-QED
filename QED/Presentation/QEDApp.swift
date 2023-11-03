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
                    FormationSettingView(
                        performance: mockPerformance1,
                        performanceUseCase: DefaultPerformanceUseCase(
                            performanceRepository: MockPerformanceRepository(),
                            userStore: DefaultUserStore.shared
                        )
                    )
                }
            } else {
                AuthView(loginViewModel: LoginViewModel(isLogin: $isLogin))
            }
        }
    }
}
