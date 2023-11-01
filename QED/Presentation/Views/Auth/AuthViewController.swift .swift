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
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class AuthViewController: UIViewController, AuthUIProtocol {

     @Binding var authProvider: AuthProviderType

    init(authProvider: Binding<AuthProviderType>) {
        self._authProvider = authProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        let authorizationButton = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: .black
        )

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

    // MARK: Auth Manager

    @objc
    func tapGoogleSignInView(_ sender: Any) {
        authProvider = .google
    }

    @objc
    func tapKakaoSignInView(_ sender: Any) {
        authProvider = .kakao
    }

    @objc
    func tapAppleSignInView(_ sender: Any) {
        authProvider = .apple
    }
}
