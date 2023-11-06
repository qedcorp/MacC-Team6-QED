// Created by byo.

import SwiftUI

struct FormationSettingView: View {
    @ObservedObject private var viewModel: FormationSettingViewModel

    init(performance: Performance, performanceUseCase: PerformanceUseCase) {
        self.viewModel = FormationSettingViewModel(
            performance: performance,
            performanceUseCase: performanceUseCase
        )
    }

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea(.all)
            VStack(spacing: 22) {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        buildMusicHeadcountView()
                        buildMemoButtonView()
                        Spacer(minLength: 18)
                        if !viewModel.isZoomed {
                            buildObjectCanvasContainerView(width: geometry.size.width)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 22)
                VStack(spacing: 20) {
                    buildPresetContainerView()
                    buildFormationContainerView()
                }
            }
            .ignoresSafeArea([.keyboard, .container], edges: .bottom)
            .overlay(
                viewModel.isMemoFormPresented ?
                buildMemoFormView()
                : nil
            )
            .overlay(
                viewModel.isZoomed ?
                buildZoomableObjectCanvasContainerView()
                : nil
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    PerformanceSettingTitleView(step: 1, title: "대형짜기")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("다음") {
                        buildMemberSettingView()
                    }
                    .disabled(!viewModel.isEnabledToSave)
                }
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

    private func buildObjectCanvasContainerView(width: CGFloat) -> some View {
        VStack(spacing: 12) {
            buildObjectCanvasView(controller: viewModel.canvasController, width: width)
            buildObjectCanvasControlsView()
        }
        .modifier(disabledOpacityModifier)
    }

    private func buildObjectCanvasView(
        controller: ObjectCanvasViewController,
        width: CGFloat
    ) -> some View {
        let height = width * CGFloat(12 / Float(19))
        return ObjectCanvasView(
            controller: controller,
            formable: viewModel.currentFormation,
            headcount: viewModel.headcount,
            onChange: {
                viewModel.updateMembers(positions: $0)
            }
        )
        .frame(width: width, height: height)
        .mask {
            RoundedRectangle(cornerRadius: 6)
        }
    }

    private func buildObjectCanvasControlsView() -> some View {
        HStack {
            HistoryControlsView(
                historyControllable: viewModel.objectHistoryArchiver,
                tag: viewModel.currentFormationTag
            )
            Spacer()
            Button {
                viewModel.isZoomed.toggle()
            } label: {
                Image("zoom_\(viewModel.isZoomed ? "full" : "off")")
                    .frame(width: 30, height: 24)
            }
        }
    }

    private func buildPresetContainerView() -> some View {
        PresetContainerView(headcount: viewModel.headcount, canvasController: viewModel.canvasController)
            .modifier(disabledOpacityModifier)
    }

    private func buildFormationContainerView() -> some View {
        let itemWidth: CGFloat = 94
        return GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(
                        Array(viewModel.formations.enumerated()),
                        id: \.offset
                    ) { formationOffset, formation in
                        buildFormationItemView(index: formationOffset, formation: formation)
                    }
                    .frame(width: itemWidth)
                    buildFormationAddButton()
                }
                .frame(height: 79)
                .padding(.horizontal, geometry.size.width / 2 - itemWidth / 2)
                .padding(.top, 12)
            }
        }
        .frame(height: 110)
        .background(
            Image("bottom")
                .resizable()
                .shadow(color: .monoBlack.opacity(0.4), radius: 3, y: -3)
        )
    }

    private func buildFormationAddButton() -> some View {
        Button {
            viewModel.addFormation()
        } label: {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.blueLight3, style: StrokeStyle(lineWidth: 1.5, dash: [1.5]))
                    Image(systemName: "plus")
                        .foregroundStyle(Color.blueLight3)
                        .font(.title3.weight(.bold))
                }
                .frame(width: 94, height: 61)
                Spacer()
            }
        }
    }

    private func buildFormationItemView(index: Int, formation: FormationModel) -> some View {
        let isSelected = index == viewModel.currentFormationIndex
        let cornerRadius: CGFloat = 5
        return VStack(alignment: .leading, spacing: 4) {
            ObjectStageView(formable: formation)
                .frame(width: 94, height: 61)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(isSelected ? Color.blueLight2 : Color.monoNormal1)
                        .blur(radius: 50)
                )
                .overlay(
                    isSelected ?
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Color.blueLight3, lineWidth: 1)
                    : nil
                )
                .overlay(
                    !isSelected ?
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)
                    : nil
                )
                .mask {
                    RoundedRectangle(cornerRadius: cornerRadius)
                }
            Text(formation.memo ?? "대형 \(index + 1)")
                .foregroundStyle(isSelected ? Color.blueLight3 : Color.monoWhite3)
                .font(.caption2.weight(.bold))
                .lineLimit(1)
                .frame(height: 13)
        }
        .contextMenu {
            ControlGroup {
                Button("삭제") {
                    viewModel.removeFormation(index: index)
                }
                Button("복제") {
                    viewModel.duplicateFormation(index: index)
                }
            }
        }
        .aspectRatio(94 / 79, contentMode: .fit)
        .onTapGesture {
            viewModel.selectFormation(index: index)
        }
    }

    private func buildFormationItemControlsView(index: Int) -> some View {
        let itemFrame = viewModel.formationItemFrameMap[index] ?? .zero
        let margin: CGFloat = 3
        return HStack {
            Button("삭제") {
                viewModel.removeFormation(index: index)
            }
            Button("복제") {
                viewModel.duplicateFormation(index: index)
            }
        }
        .frame(width: max(itemFrame.width - margin * 2, 0), height: 56)
        .background(.gray.opacity(0.5))
        .offset(x: itemFrame.minX + margin, y: -52)
    }

    private func buildMemoFormView() -> some View {
        MemoFormView(
            memo: viewModel.currentFormation?.memo ?? "",
            onComplete: { viewModel.updateCurrentMemo($0) }
        )
    }

    private func buildZoomableObjectCanvasContainerView() -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ZoomableView {
                    buildObjectCanvasView(
                        controller: viewModel.zoomableCanvasController,
                        width: geometry.size.width - 44 // TRICK: Zoom 여부 상관 없이 같은 frame을 갖도록 하기 위함
                    )
                }
                buildObjectCanvasControlsView()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 115)
            }
        }
        .ignoresSafeArea()
    }

    private func buildMemberSettingView() -> some View {
        MemberSettingView(
            performance: viewModel.performanceSettingManager.performance,
            performanceUseCase: viewModel.performanceUseCase
        )
    }
}

#Preview {
    NavigationView {
        FormationSettingView(
            performance: mockPerformance1,
            performanceUseCase: DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
        )
    }
}
