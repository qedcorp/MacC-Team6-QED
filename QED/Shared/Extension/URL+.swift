//
//  URL+.swift
//  QED
//
//  Created by changgyo seo on 1/21/24.
//

import Foundation

extension URL {
    func getQueryParameters() -> [String: String] {
        guard let query = query()?.split(separator: "&").map({ $0.split(separator: "=").map({ String($0) }) }) else { return [:] }
        var dictoinary: [String: String] = [:]
        query.forEach { arr in
            dictoinary[arr[0]] = arr[1]
        }

        return dictoinary
    }
}
