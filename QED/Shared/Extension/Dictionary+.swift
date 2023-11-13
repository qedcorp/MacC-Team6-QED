//
//  Dictionary+.swift
//  QED
//
//  Created by changgyo seo on 11/5/23.
//

import Foundation

extension Dictionary where Key == ClosedRange<CGFloat> {

    public subscript(number: CGFloat) -> Value? {
        for element in self {
            if element.key.contains(number) {
                return element.value
            }
        }
        return nil
    }
}

extension Dictionary where Key == ClosedRange<Int> {

    public subscript(number: Int) -> Value? {
        for element in self {
            if element.key.contains(number) {
                return element.value
            }
        }
        return nil
    }

    func getKeyRange(number: Int) -> Key? {
        for element in self {
            if element.key.contains(number) {
                return element.key
            }
        }
        return nil
    }
}
