// Created by byo.

import SwiftUI

struct MemberSettingView: View {
    let dependency: MemberSettingViewDependency
    @Binding var path: [PresentType]
    @StateObject private var viewModel = MemberSettingViewModel()

    var body: some View {
        ZStack {
            buildBackgroundView()
            VStack(spacing: 0) {
                buildMusicHeadcountView()
                ScrollViewReader { scrollView in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Array(viewModel.memberInfos.enumerated()), id: \.offset) { infoOffset, info in
                                buildMemberInfoButton(index: infoOffset, memberInfo: info)
                            }
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 24)
                    }
                    .onChange(of: viewModel.selectedMemberInfoIndex) {
                        guard let id = $0 else {
                            return
                        }
                        withAnimation {
                            scrollView.scrollTo(id, anchor: .center)
                        }
                    }
                }
                ScrollView(.vertical) {
                    VStack(spacing: 30) {
                        ForEach(Array(viewModel.formations.enumerated()), id: \.offset) { formationOffset, formation in
                            buildFormationItemView(index: formationOffset, formation: formation)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
                }
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
                PerformanceSettingTitleView(step: 2, title: "인물지정")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("완료")
                    .foregroundStyle(viewModel.isEnabledToSave ? Color.blueLight3 : .gray)
                    .onTapGesture {
                        if let nextPath = viewModel.nextPath {
                            path = [nextPath]
                        }
                    }
            }
        }
        .task {
            viewModel.setupWithDependency(dependency)
        }
    }

    private func buildBackgroundView() -> some View {
        Image("background")
            .resizable()
            .ignoresSafeArea(.all)
    }

    private func buildMusicHeadcountView() -> some View {
        MusicHeadcountView(title: viewModel.musicTitle, headcount: viewModel.headcount)
    }

    private func buildMemberInfoButton(index: Int, memberInfo: MemberInfoModel) -> some View {
        let cornerRadius: CGFloat = 10
        return HStack(spacing: 3) {
            Circle()
                .fill(Color(hex: memberInfo.color))
                .frame(height: 18)
                .aspectRatio(contentMode: .fit)
            Text(memberInfo.name)
                .foregroundStyle(Color.monoWhite3)
                .font(.subheadline)
        }
        .frame(height: 40)
        .padding(.horizontal, 9)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(index == viewModel.selectedMemberInfoIndex ? Color.blueLight2 : Color.monoNormal1)
        )
        .overlay(
            ZStack {
                if index == viewModel.selectedMemberInfoIndex {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.blueGradation2, lineWidth: 1)
                } else {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)
                }
            }
        )
        .id(index)
        .onTapGesture {
            viewModel.selectMember(index: index)
        }
    }

    private func buildFormationItemView(index: Int, formation: FormationModel) -> some View {
        let cornerRadius: CGFloat = 6
        return VStack(spacing: 8) {
            ObjectColorAssigningView(
                formable: formation,
                colorHex: viewModel.selectedMemberInfo?.color,
                onChange: {
                    viewModel.updateMembers(colors: $0, formationIndex: index)
                }
            )
            .aspectRatio(35 / 22, contentMode: .fit)
            Text(formation.memo ?? "대형 \(index + 1)")
                .foregroundStyle(Color.monoWhite3)
                .font(.title3)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(height: 46)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.monoNormal1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.strokeGlass2)
                )
        }
    }

    private func buildMemberInfoEditingView() -> some View {
        MemberInfoEditingView(
            memberInfos: viewModel.memberInfos,
            index: viewModel.editingMemberInfoIndex!,
            onComplete: {
                viewModel.updateEditingMemberInfo($0)
            }
        )
    }
}
