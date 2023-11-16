//
//  CGPoint+OperationOverloading.swift
//  QED
//
//  Created by changgyo seo on 11/17/23.
//

import Foundation

extension CGPoint {
    static func ~= (lhs: CGPoint, rhs: CGPoint) -> Bool {
        return abs(lhs.x - rhs.x) <= 1 && abs(lhs.y - rhs.y) <= 1
    }
}
