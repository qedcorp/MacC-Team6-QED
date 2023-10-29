// Created by byo.

import SwiftUI

struct FormationSetupView: View {
    @ObservedObject private var viewModel: FormationSetupViewModel
    private let objectCanvasViewController = ObjectCanvasViewController()

    init(performance: Performance, performanceUseCase: PerformanceUseCase) {
        let performanceSettingManager = PerformanceSettingManager(
            performance: performance,
            sizeable: objectCanvasViewController.view
        )
        self.viewModel = FormationSetupViewModel(
            performanceSettingManager: performanceSettingManager,
            performanceUseCase: performanceUseCase
        )
    }

    var body: some View {
        VStack(spacing: 26) {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    buildMusicHeadcountView()
                    buildMemoButtonView()
                    Spacer(minLength: 18)
                    buildObjectCanvasView(width: geometry.size.width)
                    Spacer()
                }
            }
            .padding(.horizontal, 22)
            VStack(spacing: 0) {
                buildPresetContainerView()
                buildFormationContainerView()
            }
        }
        .ignoresSafeArea(.keyboard)
        .overlay(
            viewModel.isMemoFormPresented ?
            buildMemoFormView()
            : nil
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PerformanceSetupTitleView(step: 1, title: "대형짜기")
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("다음") {
                    buildMemberSetupView()
                }
                .disabled(!viewModel.isEnabledToSave)
            }
        }
    }

    private var disabledOpacityModifier: DisabledOpacityModifier {
        DisabledOpacityModifier(isDisabled: !viewModel.isEnabledToEdit, disabledOpacity: 0.3)
    }

    private func buildMusicHeadcountView() -> some View {
        MusicHeadcountView(title: viewModel.musicTitle, headcount: viewModel.headcount)
            .padding(.bottom, 16)
    }

    private func buildMemoButtonView() -> some View {
        MemoButtonView(memo: viewModel.currentFormation?.memo)
            .modifier(disabledOpacityModifier)
            .onTapGesture {
                viewModel.isMemoFormPresented = true
            }
    }

    private func buildObjectCanvasView(width: CGFloat) -> some View {
        let height = width * CGFloat(22 / Float(35))
        return VStack(spacing: 6) {
            ObjectCanvasView(
                controller: objectCanvasViewController,
                headcount: viewModel.headcount,
                onChange: {
                    viewModel.updateMembers(positions: $0)
                }
            )
            .frame(width: width, height: height)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.gray.opacity(0.1))
            )
            .clipped()
            HStack {
                HistoryControlsView(
                    historyController: objectCanvasViewController.objectCanvasArchiver,
                    tag: viewModel.currentFormationTag
                )
                Spacer()
            }
        }
        .modifier(disabledOpacityModifier)
        .onChange(of: viewModel.currentFormation) {
            guard let formable = $0 else {
                return
            }
            objectCanvasViewController.copyFormable(formable)
        }
    }

    private func buildPresetContainerView() -> some View {
        PresetContainerView(headcount: viewModel.headcount, objectCanvasViewController: objectCanvasViewController)
            .modifier(disabledOpacityModifier)
    }

    private func buildFormationContainerView() -> some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(.white)
                .frame(height: 106)
            VStack(spacing: 0) {
                buildFormationAddButton()
                ZStack {
                    if viewModel.formations.isEmpty {
                        Text("프레임을 추가한 후 가사와 대형을 설정하세요.")
                            .foregroundStyle(.green)
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(
                                Array(viewModel.formations.enumerated()),
                                id: \.offset
                            ) { formationOffset, formation in
                                buildFormationItemView(index: formationOffset, formation: formation)
                            }
                            Spacer()
                        }
                        .frame(height: 64)
                        .padding(.horizontal, 14)
                        .padding(.bottom, 14)
                    }
                }
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 2, y: -2)
    }

    private func buildFormationAddButton() -> some View {
        let buttonLength: CGFloat = 52
        return Button {
            viewModel.addFormation()
        } label: {
            Circle()
                .foregroundColor(.green)
                .frame(width: buttonLength)
                .aspectRatio(contentMode: .fit)
                .overlay(
                    Circle()
                        .strokeBorder(.white, lineWidth: 6)
                )
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.system(size: buttonLength / 2, weight: .bold))
                )
        }
    }

    private func buildFormationItemView(index: Int, formation: FormationModel) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            ObjectStageView(formable: formation)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.1))
                )
                .overlay(
                    index == viewModel.currentFormationIndex ?
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(.green, lineWidth: 1)
                    : nil
                )
                .clipped()
            Text(formation.memo ?? "대형 \(index + 1)")
                .font(.caption)
                .lineLimit(1)
        }
        .aspectRatio(41 / 32, contentMode: .fit)
        .contextMenu {
            ControlGroup {
                Button("삭제") {
                    viewModel.removeFormation(index: index)
                }
                Button("복제") {
                    viewModel.duplicateFormation(index: index)
                }
            }
            .controlGroupStyle(.compactMenu)
        }
        .onTapGesture {
            viewModel.currentFormationIndex = index
        }
    }

    private func buildMemoFormView() -> some View {
        MemoFormView(
            memo: viewModel.currentFormation?.memo ?? "",
            onSubmit: { viewModel.updateCurrentMemo($0) },
            onDismiss: { viewModel.isMemoFormPresented = false }
        )
    }

    private func buildMemberSetupView() -> some View {
        MemberSetupView(
            performance: viewModel.performanceSettingManager.performance,
            performanceUseCase: viewModel.performanceUseCase
        )
    }
}
