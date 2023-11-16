// Created by byo.

import Foundation

class ViewDependency: Equatable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: ViewDependency, rhs: ViewDependency) -> Bool {
        lhs === rhs
    }
}
