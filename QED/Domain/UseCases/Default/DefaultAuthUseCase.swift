//
//  DefaultAuthUseCase.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

struct DefaultAuthUseCase: AuthUseCase {

    let kakaoAuthRepository: KakaoAuthRepository
    let googleAuthRepository: GoogleAuthRepository
    let appleAuthRepository: AppleAuthRepository

    func login(authType: AuthProviderType) async throws -> Bool {
        do {
            switch authType {
            case .kakao:
                return try await kakaoAuthRepository.login()
            case .apple:
                return try await appleAuthRepository.login()
            case .google:
                return try await googleAuthRepository.login()
            }
        } catch {
            print("--------------------")
            print("Fail to social login")
            print("--------------------")
            return false
        }
    }
}
