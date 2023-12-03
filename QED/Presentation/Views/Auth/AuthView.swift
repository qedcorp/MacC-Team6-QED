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
        // swiftlint:disable:next force_cast
        let controller = DIContainer.shared.resolver.resolve(AuthUIProtocol.self) as! AuthViewController
        loginViewModel.updateAuthUseCase()
        return controller
    }

    func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {
    }
}

@MainActor
class LoginViewModel: ObservableObject {
    static let shared = LoginViewModel()

    private var authUseCase: AuthUseCase?
    private var bag = Set<AnyCancellable>()
    @Published var authProvider: AuthProviderType = .apple
    @Published var isLogin: Bool = false

    private init() {
        subscribeAuthProvider()
    }

    private func subscribeAuthProvider() {
        $authProvider
            .dropFirst()
            .sink { [unowned self] provider in
                Task {
                    guard let loginResult = try? await authUseCase?.login(authType: provider) else {
                        return
                    }
                    isLogin = loginResult
                }
            }
            .store(in: &bag)
    }

    func updateAuthUseCase() {
        authUseCase = DIContainer.shared.resolver.resolve(AuthUseCase.self)
    }

    func logout() {
        isLogin = false
    }
}
