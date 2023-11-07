// Created by byo.

import SwiftUI
import FirebaseFirestore

import Combine

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isLogin = false

    var body: some Scene {
        WindowGroup {
            if isLogin || (try? KeyChainManager.shared.read(account: .id)) != nil {
                NavigationView {
                    MainView()
                }
            } else {
                AuthView(loginViewModel: LoginViewModel(isLogin: $isLogin))
            }
        }
    }
}
