//
//  TypeDictionary.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

struct TypeDictionary {
    private var dictionary: [ObjectIdentifier: (Any)] = [:]

    subscript<T>(key: T.Type) -> Any? {
        get {
            return dictionary[ObjectIdentifier(key)]
        }
        set {
            dictionary[ObjectIdentifier(key)] = newValue
        }
    }
}
