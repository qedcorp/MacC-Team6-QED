//
//  KeyChainError.swift
//  QED
//
//  Created by changgyo seo on 10/18/23.
//

import Foundation

enum KeyChainError: LocalizedError {
    case unhandledError(status: OSStatus)
    case itemNotFound

    var errorDescription: String? {
        switch self {
        case .unhandledError(let status):
            return "KeyChain unhandle Error: \(status)"
        case .itemNotFound:
            return "KeyChain item Not Found"
        }
    }
}
