//
//  AuthViewModel.swift
//  QED
//
//  Created by changgyo seo on 10/30/23.
//

import Foundation

import Combine

class AuthViewModel: ObservableObject {
    var authUseCase: AuthUseCase

    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
    }
}
