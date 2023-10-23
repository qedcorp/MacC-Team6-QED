// Created by byo.

import ComposableArchitecture
import SwiftUI

struct MemberSetupView: View {
    private typealias ViewStore = ViewStoreOf<MemberSetupReducer>

    let store: StoreOf<MemberSetupReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                MusicHeadcountView(title: viewStore.music.title, headcount: viewStore.headcount)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(viewStore.memberInfos.enumerated()), id: \.offset) { infoOffset, info in
                            buildMemberInfoButton(viewStore: viewStore, index: infoOffset, memberInfo: info)
                        }
                    }
                    .padding(22)
                }
                ScrollView(.vertical) {
                    VStack(spacing: 30) {
                        ForEach(Array(viewStore.formations.enumerated()), id: \.offset) { _, formation in
                            MemberSetupFormationView(formation: formation, colorHex: viewStore.selectedMemberInfo?.color)
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, 22)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    PerformanceSetupTitleView(step: 2, title: "인물지정")
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

    private func buildMemberInfoButton(viewStore: ViewStore, index: Int, memberInfo: MemberInfoModel) -> some View {
        Button {
            viewStore.send(.memberInfoButtonTapped(index))
        } label: {
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
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray.opacity(0.1))
                    .overlay(
                        index == viewStore.selectedMemberInfoIndex ?
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(.green, lineWidth: 2)
                        : nil
                    )
            )
        }
    }
}
