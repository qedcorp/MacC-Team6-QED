// Created by byo.

import SwiftUI

struct ContentView: View {
    @StateObject private var loginViewModel = LoginViewModel.shared
    @State var isLoading = true

    var body: some View {
        ZStack {
            if loginViewModel.isLogin || (try? KeyChainManager.shared.read(account: .id)) != nil {
                MainView()
            } else {
                AuthView(loginViewModel: loginViewModel)
                    .ignoresSafeArea()
            }

            Image("splash")
                .ignoresSafeArea(.all)
                .opacity(isLoading ? 1 : 0)

            ToastContainerView()
        }
        .preferredColorScheme(.dark)
        .tint(.blueLight3)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                animate {
                    isLoading.toggle()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
