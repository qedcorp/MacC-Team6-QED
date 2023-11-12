//
//  DefaultKakaoAuthRepository.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

import FirebaseCore
import FirebaseAuth
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class DefaultKakaoAuthRepository: KakaoAuthRepository {

    func login() async throws -> Bool {

        var firebaseAuthResult: AuthDataResult?

        if UserApi.isKakaoTalkLoginAvailable() {
            firebaseAuthResult =  try? await kakaoLoginInApp()
        } else {
            firebaseAuthResult =  try await kakaoLoginInWeb()
        }

        if firebaseAuthResult != nil {
            do {
                try registerKeyChain(with: firebaseAuthResult!, provider: .kakao)
                return true
            } catch {
                return false
            }
        }
        return false
    }

    func logout() async throws {
        try unregisterKeyChain(accounts: KeyChainAccount.allCases)
    }
}

fileprivate extension DefaultKakaoAuthRepository {
    private func kakaoLoginInApp() async throws -> AuthDataResult {
        return await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, _ in
                if oauthToken != nil {
                    Task {
                        guard let result = try? await self.getAuthorizationFromFirebase() else { return }
                        continuation.resume(returning: result)
                    }
                }
            }
        }
    }

    private func kakaoLoginInWeb() async throws -> AuthDataResult {
        return await withCheckedContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, _ in
                if oauthToken != nil {
                    Task {
                        guard let result = try? await self.getAuthorizationFromFirebase() else { return }
                        continuation.resume(returning: result)
                    }
                }
            }
        }
    }

    private func getAuthorizationFromFirebase() async throws -> AuthDataResult {
        return await withCheckedContinuation { continuation in
            UserApi.shared.me { user, _ in
                Task {
                    // 우선회원가입을 한다.
                    guard let firebaseAuthResult = try? await Auth.auth().createUser(
                        withEmail: (user?.kakaoAccount?.email)!,
                        password: "\(String(describing: user?.id))"
                    ) else {
                        // 회원가입이 실패했으면 이미 기존에 있던 회원이기에 로그인을 한다.
                        guard let firebaseAuthResult = try? await Auth.auth().signIn(
                            withEmail: (user?.kakaoAccount?.email)!,
                            password: "\(String(describing: user?.id))"
                        ) else { return }
                        continuation.resume(returning: firebaseAuthResult)
                        return
                    }
                    continuation.resume(returning: firebaseAuthResult)
                }
            }
        }
    }
}
