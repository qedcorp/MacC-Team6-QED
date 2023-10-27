//
//  AuthProviderType.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

enum AuthProviderType {
    case kakao
    case apple
    case google

    var description: String {
        switch self {
        case .kakao:
            return "KAKAO"
        case .apple:
            return "APPLE"
        case .google:
            return "GOOGLE"
        }
    }
}
