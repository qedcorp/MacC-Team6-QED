//
//  AuthView.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Combine
import SwiftUI

@MainActor
struct AuthView: UIViewControllerRepresentable {
    @ObservedObject var loginViewModel: LoginViewModel

    func makeUIViewController(context: Context) -> AuthViewController {
        let authViewController = AuthViewController(authProvider: $loginViewModel.temp)
        DIContainer.shared.resolver.dependencyInjection(providerType: authViewController)
        loginViewModel.subscribe()

        return authViewController
    }

    func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {

    }
}

@MainActor
class LoginViewModel: ObservableObject {
    static let shared = LoginViewModel()

    var bag = Set<AnyCancellable>()
    var authUseCase: AuthUseCase?

    @Published var temp: AuthProviderType = .apple
    @Published var isLogin: Bool = false

    private init() {}

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

    func logout() {
        self.isLogin = false
    }
}
