// Created by byo.

import Foundation

struct FormationModel: Equatable, Formable {
    var memo: String?
    var relativePositions: [RelativePosition] = []

    static func build(entity: Formation) -> Self {
        FormationModel(
            memo: entity.memo,
            relativePositions: entity.relativePositions
        )
    }
}
