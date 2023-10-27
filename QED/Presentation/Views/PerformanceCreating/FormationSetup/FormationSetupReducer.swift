// Created by byo.

import ComposableArchitecture
import Foundation

struct FormationSetupReducer: Reducer {
    struct State: Equatable {
        let music: Music
        let headcount: Int
        var isMemoFormPresented: Bool = false
        var formations: [FormationModel] = []
        var currentFormationIndex: Int = -1

        init(performance: Performance) {
            // swiftlint:disable:next force_cast
            self.music = performance.playable as! Music
            self.headcount = performance.headcount
        }

        var isAvailableToEdit: Bool {
            currentFormationIndex >= 0
        }

        var isAvailableToSave: Bool {
            !formations.isEmpty &&
            formations.allSatisfy { $0.relativePositions.count == headcount }
        }

        var currentFormation: FormationModel? {
            guard (0 ..< formations.count).contains(currentFormationIndex) else {
                return nil
            }
            return formations[currentFormationIndex]
        }
    }

    enum Action: Equatable {
        case memoTapped
        case currentMemoChanged(String?)
        case formationChanged([RelativePosition])
        case formationAddButtonTapped
        case formationTapped(Int)
        case formationDeleteButtonTapped(Int)
        case formationDuplicateButtonTapped(Int)
        case setMemoFormPresented(Bool)
        case setFormations([FormationModel])
        case setCurrentFormationIndex(Int)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .memoTapped:
            return .send(.setMemoFormPresented(true))

        case let .currentMemoChanged(memo):
            var formations = state.formations
            if var formation = state.currentFormation {
                formation.memo = memo
                formations[state.currentFormationIndex] = formation
                return .concatenate([
                    .send(.setFormations(formations)),
                    .send(.setMemoFormPresented(false))
                ])
            } else {
                return .none
            }

        case let .formationChanged(relativePositions):
            var formations = state.formations
            let formation = FormationModel(
                memo: state.currentFormation?.memo,
                members: relativePositions
                    .map { .init(relativePosition: $0) }
            )
            formations[state.currentFormationIndex] = formation
            return .send(.setFormations(formations))

        case .formationAddButtonTapped:
            let tempFormation = FormationModel()
            let formations = state.formations + [tempFormation]
            return .concatenate([
                .send(.setFormations(formations)),
                .send(.setCurrentFormationIndex(formations.count - 1))
            ])

        case let .formationTapped(index):
            return .send(.setCurrentFormationIndex(index))

        case let .formationDeleteButtonTapped(index):
            var formations = state.formations
            formations.remove(at: index)
            return .concatenate([
                .send(.setFormations(formations)),
                .send(.setCurrentFormationIndex(index == state.currentFormationIndex ? index - 1 : index))
            ])

        case let .formationDuplicateButtonTapped(index):
            var formations = state.formations
            let formation = formations[index]
            formations.insert(formation, at: index + 1)
            return .concatenate([
                .send(.setFormations(formations)),
                .send(.setCurrentFormationIndex(index + 1))
            ])

        case let .setMemoFormPresented(isPresented):
            state.isMemoFormPresented = isPresented
            return .none

        case let .setFormations(formations):
            state.formations = formations
            return .none

        case let .setCurrentFormationIndex(index):
            state.currentFormationIndex = index
            return .none
        }
    }
}
