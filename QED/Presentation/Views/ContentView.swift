// Created by byo.

import SwiftUI

struct ContentView: View {
    @StateObject private var loginViewModel = LoginViewModel.shared

    var body: some View {
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

#Preview {
    ContentView()
}
