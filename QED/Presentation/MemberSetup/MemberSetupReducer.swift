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
        var presentedMemberNameChangeIndex: Int?
        var presentedMemberColorChangeIndex: Int?

        init(performance: Performance) {
            // TODO: Playable 대응
            // swiftlint:disable:next force_cast
            self.music = performance.playable as! Music
            self.headcount = performance.headcount
            self.memberInfos = (1 ... performance.headcount)
                .map { MemberInfoModel(color: .randomHex(), name: "인물 \($0)") }
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
    }

    enum Action: Equatable {
        case memberInfoButtonTapped(Int)
        case memberNameChangeButtonTapped(Int)
        case memberColorChangeButtonTapped(Int)
        case setSelectedMemberInfoIndex(Int?)
        case setPresentedMemberNameChangeIndex(Int?)
        case setPresentedMemberColorChangeIndex(Int?)
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .memberInfoButtonTapped(index):
            return .send(.setSelectedMemberInfoIndex(index == state.selectedMemberInfoIndex ? nil : index))

        case let .memberNameChangeButtonTapped(index):
            return .send(.setPresentedMemberNameChangeIndex(index))

        case let .memberColorChangeButtonTapped(index):
            return .send(.setPresentedMemberColorChangeIndex(index))

        case let .setSelectedMemberInfoIndex(index):
            state.selectedMemberInfoIndex = index
            return .none

        case let .setPresentedMemberNameChangeIndex(index):
            state.presentedMemberNameChangeIndex = index
            return .none

        case let .setPresentedMemberColorChangeIndex(index):
            state.presentedMemberColorChangeIndex = index
            return .none
        }
    }
}
