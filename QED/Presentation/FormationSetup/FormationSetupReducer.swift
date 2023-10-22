// Created by byo.

import ComposableArchitecture
import Foundation

struct FormationSetupReducer: Reducer {
    struct State: Equatable {
        let music: Music
        let headcount: Int
        var formations: [FormationModel] = []
        var currentFormationIndex: Int = -1

        var isEnabled: Bool {
            currentFormationIndex >= 0
        }

        var currentFormation: FormationModel? {
            guard (0 ..< formations.count).contains(currentFormationIndex) else {
                return nil
            }
            return formations[currentFormationIndex]
        }
    }

    enum Action: Equatable {
        case viewAppeared
        case formationChanged([RelativePosition])
        case formationAddButtonTapped
        case formationTapped(Int)
        case setFormations([FormationModel])
        case setCurrentFormationIndex(Int)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .viewAppeared:
            return .none

        case let .formationChanged(relativePositions):
            var formations = state.formations
            let formation = FormationModel(
                memo: state.currentFormation?.memo,
                relativePositions: relativePositions
            )
            formations[state.currentFormationIndex] = formation
            return .send(.setFormations(formations))

        case .formationAddButtonTapped:
            let tempFormation = FormationModel(memo: UUID().uuidString)
            let formations = state.formations + [tempFormation]
            return .concatenate([
                .send(.setFormations(formations)),
                .send(.setCurrentFormationIndex(formations.count - 1))
            ])

        case let .formationTapped(index):
            return .send(.setCurrentFormationIndex(index))

        case let .setFormations(formations):
            state.formations = formations
            return .none

        case let .setCurrentFormationIndex(index):
            state.currentFormationIndex = index
            return .none
        }
    }
}
