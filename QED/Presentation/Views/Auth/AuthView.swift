//
//  AuthView.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import SwiftUI

struct AuthView: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> AuthViewController {
        DIContainer.shared.storage.resolver.resolve(MusicRepository.self) as! AuthViewController
    }

    func updateUIViewController(_ uiViewController: AuthViewController, context: Context) {
        // print(provider)
    }
}

class ViewModel: ObservableObject {
    @Published var temp: AuthProviderType = .apple
}
