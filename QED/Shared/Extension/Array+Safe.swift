// Created by byo.

import Foundation

extension Array {
    subscript(safe index: Array.Index) -> Element? {
        get { indices ~= index ? self[index] : nil }
        set {
            guard let element = newValue else {
                return
            }
            self[index] = element
        }
    }
}
