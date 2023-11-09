//
//  MyPageViewModel.swift
//  QED
//
//  Created by chaekie on 11/7/23.
//

import Foundation

class MyPageViewModel: ObservableObject {
    let authUseCase: AuthUseCase
    @Published var user = User(id: "")
    @Published var signUpPeriod = 1
    @Published var alertMessage: [Message?] = []

    init() {
        self.authUseCase = DIContainer.shared.resolver.resolve(AuthUseCase.self)
        alertMessage = [
            .destruction(title: AlertMessage.logout.title,
                         body: AlertMessage.logout.body,
                         label: AlertMessage.logout.lebel,
                         action: logout),
            .destruction(title: AlertMessage.withdrawal.title,
                         body: AlertMessage.withdrawal.body,
                         label: AlertMessage.withdrawal.lebel,
                         action: withdraw)
        ]
    }

    func getMe() {
        Task {
            do {
                user.id = try KeyChainManager.shared.read(account: .id)
                user.nickname = try KeyChainManager.shared.read(account: .name)
                user.email = try KeyChainManager.shared.read(account: .email)
            } catch {
                print(error)
            }
        }
    }

    func updateNotification() {}

    func updateUser() {}

    func logout() {
        Task {
            let provider = try KeyChainManager.shared.read(account: .provider)
            switch provider {
            case "KAKAO": try await authUseCase.logout(authType: .kakao)
            case "APPLE": try await authUseCase.logout(authType: .apple)
            case "GOOGLE": try await authUseCase.logout(authType: .google)
            default: break
            }
            LoginViewModel.shared.isLogin = false
        }
    }

    func withdraw() {
        Task {
            let provider = try KeyChainManager.shared.read(account: .provider)
            switch provider {
            case "KAKAO": try await authUseCase.withdraw(authType: .kakao)
            case "APPLE": try await authUseCase.logout(authType: .apple)
            case "GOOGLE": try await authUseCase.withdraw(authType: .google)
            default: break
            }
            LoginViewModel.shared.isLogin = false
        }
    }
}
