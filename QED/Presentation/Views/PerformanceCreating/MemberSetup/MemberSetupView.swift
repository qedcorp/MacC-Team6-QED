// Created by byo.

import SwiftUI

struct MemberSetupView: View {
    @ObservedObject private var viewModel: MemberSetupViewModel

    init(performance: Performance, performanceUseCase: PerformanceUseCase) {
        let performanceSettingManager = PerformanceSettingManager(performance: performance)
        self.viewModel = MemberSetupViewModel(
            performanceSettingManager: performanceSettingManager,
            performanceUseCase: performanceUseCase
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            buildMusicHeadcountView()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(viewModel.memberInfos.enumerated()), id: \.offset) { infoOffset, info in
                        buildMemberInfoButton(index: infoOffset, memberInfo: info)
                    }
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 22)
            }
            ScrollView(.vertical) {
                VStack(spacing: 14) {
                    ForEach(Array(viewModel.formations.enumerated()), id: \.offset) { formationOffset, formation in
                        buildFormationItemView(index: formationOffset, formation: formation)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 22)
            }
        }
        .overlay(
            viewModel.editingMemberInfoIndex != nil ?
            buildMemberInfoEditingView()
            : nil
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PerformanceSetupTitleView(step: 2, title: "인물지정")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("완료") {
                    buildPerformanceWatchingView()
                }
                .disabled(!viewModel.isEnabledToSave)
            }
        }
    }

    private func buildMusicHeadcountView() -> some View {
        MusicHeadcountView(title: viewModel.musicTitle, headcount: viewModel.headcount)
    }

    private func buildMemberInfoButton(index: Int, memberInfo: MemberInfoModel) -> some View {
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
                    index == viewModel.selectedMemberInfoIndex ?
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.green, lineWidth: 2)
                    : nil
                )
        )
        .contextMenu {
            ControlGroup {
                Button("이름변경") {
                    viewModel.editingMemberInfoIndex = index
                }
            }
            .controlGroupStyle(.compactMenu)
        }
        .onTapGesture {
            viewModel.selectedMemberInfoIndex = index
        }
    }

    private func buildFormationItemView(index: Int, formation: FormationModel) -> some View {
        VStack(spacing: 10) {
            ObjectSelectionView(
                formable: formation,
                colorHex: viewModel.selectedMemberInfo?.color,
                onChange: {
                    viewModel.updateMembers(colors: $0, formationIndex: index)
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

    private func buildMemberInfoEditingView() -> some View {
        MemberInfoEditingView(
            name: viewModel.editingMemberInfo?.name ?? "",
            color: viewModel.editingMemberInfo?.color ?? "",
            onComplete: {
                viewModel.updateEditingMemberName($0)
                viewModel.editingMemberInfoIndex = nil
            }
        )
    }

    private func buildPerformanceWatchingView() -> some View {
        let performance = viewModel.performanceSettingManager.performance
        return PerformanceWatchingView(performance: performance)
    }
}
