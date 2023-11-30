// Created by byo.

import SwiftUI

struct FormationSettingView: View {
    let dependency: FormationSettingViewDependency
    @Binding var path: [PresentType]
    @StateObject private var viewModel = FormationSettingViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            buildBackgroundView()
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    let spacing: CGFloat = 21
                    VStack(spacing: 0) {
                        buildMusicHeadcountView()
                            .padding(.bottom, spacing)
                        buildMemoButtonView()
                        Spacer(minLength: spacing)
                        if !viewModel.isZoomed {
                            buildObjectCanvasContainerView(width: geometry.size.width)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                VStack(spacing: 0) {
                    if let viewModel = viewModel.presetContainerViewModel {
                        buildPresetContainerView(viewModel: viewModel)
                    }
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
            .toolbar(viewModel.isNavigationBarHidden ? .hidden : .visible, for: .navigationBar)
            .toolbar {
                if viewModel.performanceSettingManager?.isAutoUpdateDisabled == true {
                    ToolbarItem(placement: .navigationBarLeading) {
                        AlertableBackButton(alert: .back, dismiss: dismiss)
                    }
                }
                ToolbarItem(placement: .principal) {
                    PerformanceSettingTitleView(step: 1, title: "대형짜기")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("다음") {
                        guard let performanceSettingManager = viewModel.performanceSettingManager,
                              let performanceUseCase = viewModel.performanceUseCase else {
                            return
                        }
                        let dependency = MemberSettingViewDependency(
                            performanceSettingManager: performanceSettingManager,
                            performanceUseCase: performanceUseCase
                        )
                        Task {
                            try await viewModel.performanceSettingManager?.requestUpdate()
                            path.append(.memberSetting(dependency))
                        }
                    }
                    .disabled(!viewModel.isEnabledToSave)
                }
            }
        }
        .task {
            viewModel.setupWithDependency(dependency)
        }
    }

    private var disabledOpacityModifier: DisabledOpacityModifier {
        DisabledOpacityModifier(isDisabled: !viewModel.isEnabledToEdit, disabledOpacity: 0.3)
    }

    private func buildBackgroundView() -> some View {
        Image("background")
            .resizable()
            .ignoresSafeArea(.all)
    }

    private func buildMusicHeadcountView() -> some View {
        MusicHeadcountView(title: viewModel.musicTitle, headcount: viewModel.headcount)
    }

    private func buildMemoButtonView() -> some View {
        Button {
            viewModel.presentMemoForm()
        } label: {
            MemoButtonView(memo: viewModel.currentFormation?.memo, isHighlighted: !viewModel.hasMemoBeenInputted)
        }
        .modifier(disabledOpacityModifier)
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
                viewModel.toggleZoom()
            } label: {
                Image("zoom_\(viewModel.isZoomed ? "full" : "off")")
                    .frame(width: 30, height: 24)
            }
        }
    }

    private func buildPresetContainerView(viewModel: PresetContainerViewModel) -> some View {
        PresetContainerView(viewModel: viewModel)
            .modifier(disabledOpacityModifier)
    }

    private func buildFormationContainerView() -> some View {
        let itemWidth: CGFloat = 94
        return GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                ScrollViewReader { scrollView in
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
                    .simultaneousGesture(
                        DragGesture()
                            .onChanged { _ in
                                viewModel.resetControllingFormationIndex()
                            }
                    )
                    .onAppear {
                        animate {
                            scrollView.scrollTo(viewModel.currentFormationIndex, anchor: .center)
                        }
                    }
                    .onChange(of: viewModel.currentFormationIndex) { id in
                        animate {
                            scrollView.scrollTo(id, anchor: .center)
                        }
                    }
                }
                if let index = viewModel.controllingFormationIndex {
                    buildFormationItemControlsView(index: index)
                }
            }
        }
        .frame(height: 110)
        .background(
            Color.background1
                .shadow(color: .monoBlack.opacity(0.4), radius: 1.5, y: -3)
        )
    }

    private func buildFormationAddButton() -> some View {
        Button {
            viewModel.addFormation()
        } label: {
            VStack {
                Image("plusbox")
                    .frame(width: 94, height: 61)
                Spacer()
            }
        }
    }

    private func buildFormationItemView(index: Int, formation: FormationModel) -> some View {
        let isSelected = index == viewModel.currentFormationIndex
        let cornerRadius: CGFloat = 5
        return Button {
            viewModel.selectFormation(index: index)
        } label: {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 4) {
                    ObjectStageView(formable: formation)
                        .frame(width: 94, height: 61)
                        .background(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(isSelected ? Color.blueLight1 : Color.build(hex: .stageBackground))
                        )
                        .overlay(
                            ZStack {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .strokeBorder(Color.blueLight3, lineWidth: 1)
                                } else {
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .strokeBorder(Gradient.strokeGlass2, lineWidth: 0.5)
                                }
                            }
                        )
                        .mask {
                            RoundedRectangle(cornerRadius: cornerRadius)
                        }
                    HStack(spacing: 3) {
                        Text("\(index + 1)")
                            .foregroundStyle(isSelected ? Color.monoBlack : Color.monoWhite3)
                            .multilineTextAlignment(.center)
                            .frame(minWidth: 13)
                            .background(
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(isSelected ? Color.blueLight3 : Color.monoNormal2)
                            )
                        Text(formation.memo ?? "대형 \(index + 1)")
                            .foregroundStyle(isSelected ? Color.blueLight3 : Color.monoNormal2)
                            .lineLimit(1)
                    }
                    .font(.caption2.weight(isSelected ? .semibold : .regular))
                    .frame(height: 13)
                    .transaction {
                        $0.animation = nil
                    }
                }
                .id(index)
                .onAppear {
                    let frame = geometry.frame(in: .global)
                    viewModel.updateFormationItemFrameMap(frame, index: index)
                }
                .onChange(of: geometry.frame(in: .global)) {
                    viewModel.updateFormationItemFrameMap($0, index: index)
                }
            }
            .aspectRatio(94 / 79, contentMode: .fit)
        }
    }

    private func buildFormationItemControlsView(index: Int) -> some View {
        let itemFrame = viewModel.formationItemFrameMap[index] ?? .zero
        let margin: CGFloat = 3
        return HStack(spacing: 0) {
            buildFormationItemControlButton(imageName: "trash.fill", title: "삭제") {
                viewModel.removeFormation(index: index)
            }
            Rectangle()
                .fill(Gradient.strokeGlass2)
                .frame(width: 0.5)
            buildFormationItemControlButton(imageName: "plus.rectangle.fill.on.rectangle.fill", title: "복제") {
                viewModel.duplicateFormation(index: index)
            }
        }
        .frame(width: max(itemFrame.width - margin * 2, 0), height: 44)
        .background(
            Color.blueLight2
                .background(.ultraThinMaterial)
        )
        .mask {
            RoundedRectangle(cornerRadius: 5)
        }
        .offset(x: itemFrame.minX + margin, y: -38)
        .transition(
            .opacity
                .combined(with: .offset(y: 16))
                .animation(.easeOut)
        )
    }

    private func buildFormationItemControlButton(
        imageName: String,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            VStack(spacing: 2) {
                Image(systemName: imageName)
                    .font(.caption2)
                Text(title)
                    .font(.system(size: 8).weight(.medium))
            }
            .foregroundStyle(Color.monoWhite3)
        }
        .frame(width: 44)
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
                        width: geometry.size.width - 48 // TRICK: Zoom 여부 상관 없이 같은 frame을 갖도록 하기 위함
                    )
                }
                buildObjectCanvasControlsView()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 115)
            }
        }
        .ignoresSafeArea()
    }
}
