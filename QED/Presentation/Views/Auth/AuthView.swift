//
//  AuthView.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import SwiftUI

import Combine

struct AuthView: UIViewControllerRepresentable {

    @ObservedObject var loginViewModel: LoginViewModel

    func makeUIViewController(context: Context) -> AuthViewController {
        var authViewController = AuthViewController(authProvider: $loginViewModel.temp)
        DIContainer.shared.resolver.dependencyInjection(providerType: authViewController)
        loginViewModel.subscribe()

        return authViewController
    }

    func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {

    }
}

@MainActor
class LoginViewModel: ObservableObject {

    var bag = Set<AnyCancellable>()
    var authUseCase: AuthUseCase?

    @Published var temp: AuthProviderType = .apple
    @Binding var isLogin: Bool

    init(isLogin: Binding<Bool>) {
        self._isLogin = isLogin
    }

    func subscribe() {
        authUseCase = DIContainer.shared.resolver.resolve(AuthUseCase.self)
        $temp
            .dropFirst()
            .sink { provider in
                Task {
                    switch provider {
                    case .kakao:
                        guard let loginResult = try? await self.authUseCase!.login(authType: .kakao) else { return }
                        self.isLogin = loginResult
                    case .apple:
                        guard let loginResult = try? await self.authUseCase!.login(authType: .apple) else { return }
                        self.isLogin = loginResult
                    case .google:
                        guard let loginResult = try? await self.authUseCase!.login(authType: .google) else { return }
                        self.isLogin = loginResult
                    }
                }
            }
            .store(in: &bag)
    }
}
