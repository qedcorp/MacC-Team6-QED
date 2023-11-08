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
//            TODO: 로그아웃 provider 상태로 처리
//            try await authUseCase.logout(authType: .apple)
        }
    }

    func withdraw() { }
}
