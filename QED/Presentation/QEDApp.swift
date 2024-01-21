// Created by byo.

import Combine
import FirebaseFirestore
import SwiftUI
import AirBridge
import KakaoSDKCommon
import SafariServices
import KakaoSDKTemplate
import KakaoSDKShare

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
