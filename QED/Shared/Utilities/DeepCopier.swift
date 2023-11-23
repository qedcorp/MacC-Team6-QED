// Created by byo.

import Foundation

struct DeepCopier {
    private static let encoder = JSONEncoder()
    private static let decoder = JSONDecoder()

    private init() {
    }

    static func copy<T: Codable>(_ object: T) throws -> T {
        let json = try encoder.encode(object)
        return try decoder.decode(T.self, from: json)
    }
}
