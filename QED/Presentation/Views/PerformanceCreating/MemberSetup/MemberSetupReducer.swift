// Created by byo.

import ComposableArchitecture
import Foundation

struct MemberSetupReducer: Reducer {
    struct State: Equatable {
        let music: Music
        let headcount: Int
        var memberInfos: [MemberInfoModel]
        var formations: [FormationModel]
        var selectedMemberInfoIndex: Int?
        var presentedMemberInfoChangeIndex: Int?

        init(performance: Performance) {
            // TODO: Playable 대응
            // swiftlint:disable:next force_cast
            self.music = performance.playable as! Music
            self.headcount = performance.headcount
            self.memberInfos = performance.memberInfos
                .map { .build(entity: $0) }
            self.formations = performance.formations
                .map { .build(entity: $0) }
        }

        var selectedMemberInfo: MemberInfoModel? {
            guard let index = selectedMemberInfoIndex,
                  (0 ..< memberInfos.count).contains(index) else {
                return nil
            }
            return memberInfos[index]
        }

        var changingMemberInfo: MemberInfoModel? {
            guard let index = presentedMemberInfoChangeIndex,
                  (0 ..< memberInfos.count).contains(index) else {
                return nil
            }
            return memberInfos[index]
        }
    }

    enum Action: Equatable {
        case memberInfoButtonTapped(Int)
        case memberInfoChangeButtonTapped(Int)
        case memberNameChanged(String)
        case formationChanged(Int, FormationModel)
        case setMemberInfos([MemberInfoModel])
        case setFormations([FormationModel])
        case setSelectedMemberInfoIndex(Int?)
        case setPresentedMemberInfoChangeIndex(Int?)
    }

    let performanceUseCase: PerformanceUseCase

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .memberInfoButtonTapped(index):
            return .send(.setSelectedMemberInfoIndex(index == state.selectedMemberInfoIndex ? nil : index))

        case let .memberInfoChangeButtonTapped(index):
            return .send(.setPresentedMemberInfoChangeIndex(index))

        case let .memberNameChanged(name):
            var memberInfos = state.memberInfos
            // TODO: optional 관리
            memberInfos[state.presentedMemberInfoChangeIndex!].name = name
            return .send(.setMemberInfos(memberInfos))

        case let .formationChanged(index, formation):
            var formations = state.formations
            formations[index] = formation
            return .send(.setFormations(formations))

        case let .setMemberInfos(memberInfos):
            state.memberInfos = memberInfos
            return .none

        case let .setFormations(formations):
            state.formations = formations
            return .none

        case let .setSelectedMemberInfoIndex(index):
            state.selectedMemberInfoIndex = index
            return .none

        case let .setPresentedMemberInfoChangeIndex(index):
            state.presentedMemberInfoChangeIndex = index
            return .none
        }
    }
}
