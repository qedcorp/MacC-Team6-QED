// Created by byo.

import Foundation

@propertyWrapper
struct HexString {
    private static let hexCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
    private static let defaultValue = "000000"
    
    private var value = defaultValue
    
    var wrappedValue: String {
        get { value }
        set {
            guard Self.isValidHexString(newValue) else {
                return
            }
            value = newValue
        }
    }
    
    private static func isValidHexString(_ value: String) -> Bool {
        guard (6 ... 8).contains(value.count) else {
            return false
        }
        return value.rangeOfCharacter(from: hexCharacters.inverted) == nil
    }
}
