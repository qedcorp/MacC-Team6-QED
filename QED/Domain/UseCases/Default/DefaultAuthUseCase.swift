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
    let uiViewController: AuthUIProtocol

    func login(authType: AuthProviderType) async throws {
        do {
            switch authType {
            case .kakao:
                _ = try await kakaoAuthRepository.login()
            case .apple:
                _ = try await appleAuthRepository.login()
            case .google:
                _ = try await googleAuthRepository.login()
            }
        } catch {
            print("--------------------")
            print("Fail to social login")
            print("--------------------")
        }
    }
}
