//
//  GoogleAuthRepositoryImplement.swift
//  QED
//
//  Created by changgyo seo on 10/19/23.
//

import GoogleSignIn

import UIKit
import FirebaseCore
import FirebaseAuth

final class GoogleAuthRepositoryImplement: GoogleAuthRepository {

    private var authUI: AuthUIProtocol

    init(authUI: AuthUIProtocol) {
        self.authUI = authUI
    }

    func login() async throws -> Bool {
        guard let authUIViewController = authUI as? UIViewController else { return false }
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let result = try? await GIDSignIn.sharedInstance.signIn(
            withPresenting: authUIViewController
        ) else { return false }
        guard let idToken = result.user.idToken?.tokenString else { return false }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: result.user.accessToken.tokenString)

        guard let firebaseAuthResult = try? await Auth.auth().signIn(with: credential) else { return false }

        do {
            try registerKeyChain(with: firebaseAuthResult)
            return true
        } catch {
            return false
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
