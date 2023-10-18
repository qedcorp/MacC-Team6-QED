// Created by byo.

import Foundation

class FormationTransition {
    typealias Movement = Data

    var memberMovements: [Member.Info: Movement]

    init(memberMovements: [Member.Info: Movement] = [:]) {
        self.memberMovements = memberMovements
    }
}
