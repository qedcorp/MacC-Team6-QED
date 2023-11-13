//
//  AuthProviderType.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

enum AuthProviderType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case google = "GOOGLE"

    var description: String {
        self.rawValue.uppercased()
    }
}
