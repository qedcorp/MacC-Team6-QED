//
//  MyPageViewModel.swift
//  QED
//
//  Created by chaekie on 11/7/23.
//

import Foundation

class MyPageViewModel: ObservableObject {
    @Published var user: User?
    let userUseCase: DefaultUserUseCase
    let authUseCase: DefaultAuthUseCase

    init(userUseCase: DefaultUserUseCase, authUseCase: DefaultAuthUseCase) {
        self.userUseCase = userUseCase
        self.authUseCase = authUseCase
    }

    func getMe() {
        Task {
            user = try await userUseCase.getMe()
        }
    }

    func updateNotification() {}

    func updateUser() {}

    func logout() {
        Task {
            let provider = try KeyChainManager.shared.read(account: .provider)
            switch provider {
            case "KAKAO": return try await authUseCase.logout(authType: .kakao)
            case "APPLE": return try await authUseCase.logout(authType: .apple)
            case "GOOGLE": return try await authUseCase.logout(authType: .google)
            default: return
            }
        }
    }

    func withdraw() { }
}
