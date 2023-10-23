// Created by byo.

import ComposableArchitecture
import Foundation

struct MemberSetupReducer: Reducer {
    struct State: Equatable {
        let music: Music
        let headcount: Int
        var selectedMemberInfo: Member.Info?
        var formations: [FormationModel]

        init(performance: Performance) {
            // TODO: Playable 대응
            // swiftlint:disable:next force_cast
            self.music = performance.playable as! Music
            self.headcount = performance.headcount
            self.formations = performance.formations
                .map { FormationModel(memo: $0.memo, relativePositions: $0.relativePositions) }
        }
    }

    enum Action: Equatable {
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        .none
    }
}
