// Created by byo.

import ComposableArchitecture
import SwiftUI

struct MemberSetupView: View {
    fileprivate typealias Reducer = MemberSetupReducer
    fileprivate typealias ViewStore = ViewStoreOf<Reducer>

    private let store: StoreOf<Reducer>

    init(
        performanceSettingManager: PerformanceSettingManager,
        performanceUseCase: PerformanceUseCase
    ) {
        self.store = .init(initialState: Reducer.State(performance: performanceSettingManager.performance)) {
            Reducer(performanceUseCase: performanceUseCase)
        }
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                MusicHeadcountView(
                    title: viewStore.music.title,
                    headcount: viewStore.headcount
                )
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(viewStore.memberInfos.enumerated()), id: \.offset) { infoOffset, info in
                            MemberInfoButton(
                                viewStore: viewStore,
                                index: infoOffset,
                                memberInfo: info
                            )
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 22)
                }
                ScrollView(.vertical) {
                    VStack(spacing: 14) {
                        ForEach(Array(viewStore.formations.enumerated()), id: \.offset) { formationOffset, formation in
                            FormationItem(
                                viewStore: viewStore,
                                index: formationOffset,
                                formation: formation
                            )
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 22)
                }
            }
            .overlay(
                viewStore.presentedMemberInfoChangeIndex != nil ?
                MemberInfoChangeView(
                    name: viewStore.binding(
                        get: { $0.changingMemberInfo?.name ?? "" },
                        send: { .memberNameChanged($0) }
                    ),
                    color: viewStore.changingMemberInfo?.color ?? "",
                    onDismiss: {
                        viewStore.send(.setPresentedMemberInfoChangeIndex(nil))
                    }
                )
                : nil
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    PerformanceSetupTitleView(
                        step: 2,
                        title: "인물지정"
                    )
                }
                ToolbarTitleMenu {
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                    }
                }
            }
        }
    }

    private struct MemberInfoButton: View {
        let viewStore: ViewStore
        let index: Int
        let memberInfo: MemberInfoModel

        var body: some View {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hex: memberInfo.color))
                    .frame(height: 22)
                    .aspectRatio(contentMode: .fit)
                Text(memberInfo.name)
                    .foregroundStyle(.gray)
            }
            .frame(height: 38)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.1))
                    .overlay(
                        index == viewStore.selectedMemberInfoIndex ?
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(.green, lineWidth: 2)
                        : nil
                    )
            )
            .contextMenu {
                ControlGroup {
                    Button("이름변경") {
                        viewStore.send(.memberInfoChangeButtonTapped(index))
                    }
                }
                .controlGroupStyle(.compactMenu)
            }
            .onTapGesture {
                viewStore.send(.memberInfoButtonTapped(index))
            }
        }
    }

    private struct FormationItem: View {
        let viewStore: ViewStore
        let index: Int
        let formation: FormationModel

        var body: some View {
            VStack(spacing: 10) {
                ObjectSelectionView(
                    formable: formation,
                    colorHex: viewStore.selectedMemberInfo?.color,
                    onChange: {
                        var formation = formation
                        $0.enumerated().forEach {
                            formation.members[$0.offset].color = $0.element
                        }
                        viewStore.send(.formationChanged(index, formation))
                    }
                )
                .aspectRatio(35 / 22, contentMode: .fit)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
                Text(formation.memo ?? "대형 \(index + 1)")
                    .foregroundStyle(.green)
                    .bold()
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .frame(height: 46)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.gray.opacity(0.1))
                    )
            }
        }
    }
}
