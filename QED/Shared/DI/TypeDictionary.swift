// swiftlint:disable all
//  TypeDictionary.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

class KioInjection {

    var resolver: Resolver = Resolver()

    struct Resolver {

        var DIDictionary = TypeDictionary()

        func resolve<T>(_ type: T.Type) -> T {
            return DIDictionary[type.self] as! T
        }
    }

    func register<T>(_ type: T.Type, _ completion: @escaping (Resolver) -> T) {
        let result = completion(self.resolver)

        resolver.DIDictionary[type.self] = result
    }
}

struct TypeDictionary {
    private var dictionary: [(ObjectIdentifier): (Any)] = [:]

    subscript<T>(key: T.Type) -> Any? {
        get {
            return dictionary[ObjectIdentifier(key)]
        }
        set {
            dictionary[ObjectIdentifier(key)] = newValue
        }
    }
}
