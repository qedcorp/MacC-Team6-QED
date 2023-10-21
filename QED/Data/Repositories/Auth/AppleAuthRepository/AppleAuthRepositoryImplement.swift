//
//  AppleAuthRepositoryImplement.swift
//  QED
//
//  Created by changgyo seo on 10/19/23.
//

import Foundation

import AuthenticationServices
import CryptoKit
import FirebaseCore
import FirebaseAuth

final class AppleAuthRepositoryImplement: NSObject, AppleAuthRepository {

    private var authcontinuation: CheckedContinuation<Bool, Error>?
    private var currentNonce: String?

    lazy var authorizationController: ASAuthorizationController = {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        return authorizationController
    }()

    func login() async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            authcontinuation = continuation
            authorizationController.performRequests()
        }
    }

    func logout() async throws {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            try unregisterKeyChain(accounts: [.id, .name, .email, .refreshToken])
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension AppleAuthRepositoryImplement: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else { return }
            guard let appleIDToken = appleIDCredential.identityToken else { return }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }

            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                           rawNonce: nonce,
                                                           fullName: appleIDCredential.fullName)
            Task {
                do {
                    let firebaseAuthResult = try await Auth.auth().signIn(with: credential)
                    try registerKeyChain(with: firebaseAuthResult)
                    authcontinuation?.resume(returning: true)
                } catch {
                    authcontinuation?.resume(returning: false)
                }
            }
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }

        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }

}
