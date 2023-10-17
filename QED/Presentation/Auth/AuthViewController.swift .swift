//
//  AuthViewController.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import SwiftUI

import AuthenticationServices
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    // MARK: UI
    lazy var googleSignInView: UIView = {
        let view = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGoogleSignInView(_:)))

        view.backgroundColor = .red
        view.addGestureRecognizer(gesture)

        return view
    }()

    lazy var kakaoSignInview: UIView = {
        let view = UIView()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapKakaoSignInView(_:)))

        view.backgroundColor = .blue
        view.addGestureRecognizer(gesture)

        return view
    }()

    lazy var appleSignInView: ASAuthorizationAppleIDButton = {
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)

        authorizationButton.addTarget(self, action: #selector(tapAppleSignInView(_:)), for: .touchUpInside)

        return authorizationButton
    }()

    // MARK: AutoConstraint
    func layout() {
        [googleSignInView, kakaoSignInview, appleSignInView].forEach {
            view.addSubview($0)
        }

        googleSignInView.translatesAutoresizingMaskIntoConstraints = false
        googleSignInView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        googleSignInView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        googleSignInView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        googleSignInView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        kakaoSignInview.translatesAutoresizingMaskIntoConstraints = false
        kakaoSignInview.topAnchor.constraint(equalTo: googleSignInView.bottomAnchor, constant: 30).isActive = true
        kakaoSignInview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        kakaoSignInview.widthAnchor.constraint(equalToConstant: 150).isActive = true
        kakaoSignInview.heightAnchor.constraint(equalToConstant: 100).isActive = true

        appleSignInView.translatesAutoresizingMaskIntoConstraints = false
        appleSignInView.topAnchor.constraint(equalTo: kakaoSignInview.bottomAnchor, constant: 30).isActive = true
        appleSignInView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleSignInView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        appleSignInView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    // MARK: Auth Logic
    private let clientID = FirebaseApp.app()?.options.clientID

    @objc
    func tapGoogleSignInView(_ sender: Any) {
        guard let clientID = self.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        Task {
            guard let result = try? await GIDSignIn.sharedInstance.signIn(withPresenting: self),
                  let idToken = result.user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: result.user.accessToken.tokenString)

            guard let authDataResult = try? await Auth.auth().signIn(with: credential) else { return }
        }
    }

    @objc
    func tapKakaoSignInView(_ sender: Any) {

    }

    @objc
    func tapAppleSignInView(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

}

extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authCodeString = String(data: authorizationCode, encoding: .utf8),
               let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }

            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")

        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password

            print("username: \(username)")
            print("password: \(password)")

        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("login failed - \(error.localizedDescription)")
    }
}
