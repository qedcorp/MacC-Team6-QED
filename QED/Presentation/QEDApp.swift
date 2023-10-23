// Created by byo.

import SwiftUI
import FirebaseFirestore

@main
struct QEDApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        Text("Hello, World")
            .onTapGesture {
                let repo = DefaultPresetRepository(remoteManager: FireStoreManager())

                Task {
                    let temp = try await repo.readPresets(headcount: 5)
                    print(temp.count)
                    for iii in temp {
                        print(iii.headcount)
                    }
                }
            }
    }
}
