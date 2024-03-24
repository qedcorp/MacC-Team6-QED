//
//  AppDelegate.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import SwiftUI

import AirBridge
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        KakaoSDK.initSDK(appKey: "e754bd84082fb1b6473589df6c567b66")
        FirebaseApp.configure()
        _ = DIContainer.shared
        AirBridge.getInstance("290e6069b75142ca9ddbf24d6661cb56", appName: "fodi", withLaunchOptions: launchOptions)

        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if GIDSignIn.sharedInstance.handle(url) && AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
