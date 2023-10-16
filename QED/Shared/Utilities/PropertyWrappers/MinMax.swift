// Created by byo.

import Foundation

@propertyWrapper
struct MinMax<T: Comparable> {
    private var value: T?
    private let minValue: T
    private let maxValue: T
    
    init(minValue: T, maxValue: T) {
        self.minValue = minValue
        self.maxValue = maxValue
    }
    
    var wrappedValue: T {
        get { value ?? minValue }
        set {
            value = min(max(newValue, minValue), maxValue)
        }
    }
}
