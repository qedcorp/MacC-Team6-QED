//
//  AuthProviderType.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

enum AuthProviderType: String {
    case kakao
    case apple
    case google

    var description: String {
        self.rawValue.uppercased()
    }
}
