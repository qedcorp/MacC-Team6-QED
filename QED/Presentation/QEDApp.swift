// Created by byo.

import SwiftUI
import FirebaseFirestore

import Combine

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var loginViewModel = LoginViewModel.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                if loginViewModel.isLogin || (try? KeyChainManager.shared.read(account: .id)) != nil {
                    MainView()
                } else {
                    AuthView(loginViewModel: loginViewModel)
                        .ignoresSafeArea()
                }
                ToastContainerView()
            }
            .preferredColorScheme(.dark)
            .tint(.blueLight3)
        }
    }
}
