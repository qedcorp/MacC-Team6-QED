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
                MainView()
            } else {
                AuthView(loginViewModel: LoginViewModel(isLogin: $isLogin))
            }
        }
    }
}
