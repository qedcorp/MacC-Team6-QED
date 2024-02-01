// swiftlint:disable all
//  WatchingPerformanceWatchingDetailView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct PerformanceWatchingDetailView: View {
    typealias PlayBarConstants = ScrollObservableView.Constants
    
    let dependency: PerformanceWatchingViewDependency
    @State var isShowingSharedAlert: Bool = false
    @Binding var path: [PresentType]
    @StateObject private var viewModel = PerformanceWatchingDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    if let performance = viewModel.performance {
                        MusicHeadcountView(title: performance.music.title,
                                           headcount: performance.headcount)
                        .padding(.bottom, geometry.size.height * 0.15)
                        VStack(spacing: 8) {
                            buildMemo()
                            if viewModel.isTransitionEditable && viewModel.currentIndex > 0 {
                                buildMovementEditingView(
                                    controller: viewModel.movementController,
                                    width: geometry.size.width - 48
                                )
                                buildHistoryControlsView()
                            } else {
                                buildObjectPlayView()
                            }
                        }
                        .padding(.horizontal, 24)
                        Spacer()
                        buildPlayerView(performance: performance.entity)
                    } else {
                        Spacer()
                    }
                    buildTabBar(geometry: geometry)
                }
                Color.black.opacity(viewModel.isSettingSheetVisible ? 0.4 : 0).ignoresSafeArea()
            }
        }
        .background {
            buildBackgroundView()
        }
        .overlay(
            viewModel.isZoomed ?
            buildZoomableMovementEditingView()
            : nil
        )
        .overlay(
            isShowingSharedAlert ?
            buildSharedAlertView()
            : nil
        )
        .navigationBarBackButtonHidden()
        .toolbar {
            buildLeftItem()
            buildTitleItem()
            buildRightSharedItem()
            buildRightFixItem()
        }
        .task {
            viewModel.setupWithDependency(dependency)
        }
        .onChange(of: viewModel.currentIndex) { _ in
            viewModel.objectHistoryArchiver.reset()
        }
        .onAppear {
            if viewModel.isAutoShowAllForamation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewModel.isAllFormationVisible = !true
                }
                MixpanelManager.shared.track(.watchPerformance(
                    [
                        "HowToCome": ComingPath.GeneratePerformanceYet.rawValue,
                        "hasTabbedFixSettingBtn": "no"
                    ]
                ))
            } else {
                MixpanelManager.shared.track(.watchPerformance(
                    [
                        "HowToCome": ComingPath.TabPerformanceCard.rawValue,
                        "hasTabbedFixSettingBtnf": "no"
                    ]
                ))
            }
        }
        .showModal(viewModel.isSettingSheetVisible) {
            buildSettingSheetView()
        }
        .sheet(isPresented: $viewModel.isAllFormationVisible) {
            ZStack {
                PerformanceWatchingListView(performance: viewModel.performance?.entity ?? Performance(jsonString: ""),
                                            isAllFormationVisible: $viewModel.isAllFormationVisible,
                                            selecteIndex: viewModel.selectedIndex,
                                            action: viewModel.action
                )
                ToastContainerView()
            }
        }
    }
    
    private func buildMovementEditingView(
        controller: ObjectMovementAssigningViewController,
        width: CGFloat
    ) -> some View {
        let height = width * CGFloat(12 / Float(19))
        return ZStack {
            if let beforeFormation = viewModel.beforeFormation,
               let afterFormation = viewModel.currentFormation {
                ObjectMovementAssigningView(
                    controller: controller,
                    beforeFormation: beforeFormation,
                    afterFormation: afterFormation,
                    onChange: {
                        viewModel.updateMembers(movementMap: $0)
                    }
                )
            }
        }
        .frame(width: width, height: height)
    }
    
    private func buildZoomableMovementEditingView() -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZoomableView {
                    buildMovementEditingView(
                        controller: viewModel.zoomableMovementController,
                        width: geometry.size.width
                    )
                }
            }
            buildHistoryControlsView()
                .padding()
        }
    }
    
    private func buildHistoryControlsView() -> some View {
        HStack {
            HistoryControlsView(
                historyControllable: viewModel.objectHistoryArchiver,
                tag: viewModel.movementMapTag
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
    
    private func buildSharedAlertView() -> some View {
        ZStack {
            Color.build(hex: .modalBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    isShowingSharedAlert = false
                }
            VStack {
                Spacer(minLength: 218)
                if let performance = viewModel.performance {
                    SharedAlert(pId: viewModel.performance?.id ?? "",music: performance.music)
                        .frame(width: 342, height: 226)
                }
                Rectangle()
                    .foregroundStyle(.clear)
            }
        }
    }
    
    private func buildObjectPlayView() -> some View {
        ZStack {
            Image(viewModel.isLineVisible ? "stage" : "stage_nongrid")
            if viewModel.isLoading {
                ProgressView()
            }
            if let movementsMap = viewModel.movementsMap {
                ObjectPlayableView(movementsMap: movementsMap,
                                   totalCount: viewModel.performance?.formations.count ?? 0,
                                   offset: $viewModel.offset,
                                   isShowingPreview: $viewModel.isBeforeVisible,
                                   isLoading: $viewModel.isLoading,
                                   isNameVisiable: $viewModel.isNameVisiable
                )
            }
        }
        .frame(height: 216)
    }
    
    private func buildMemo() -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.monoNormal1)
                .frame(height: 46)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Gradient.strokeGlass3, lineWidth: 1)
                )
            
            Text(viewModel.currentMemo)
                .foregroundStyle(Color.monoWhite3)
                .font(.title3)
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }
    
    private func buildPlayerView(performance: Performance) -> some View {
        ZStack {
            ScrollObservableView(performance: performance, action: viewModel.action)
                .frame(height: PlayBarConstants.playBarHeight)
        }
        .padding(.bottom)
    }
    
    private func buildTabBar(geometry: GeometryProxy) -> some View {
        ZStack {
            HStack {
                Button {
                    withAnimation(.spring) {
                        viewModel.isTransitionEditable.toggle()
                        if viewModel.isTransitionEditable {
                            if viewModel.selectedIndex == 0 {
                                viewModel.action.send(.setSelectedIndex(1))
                            }
                            viewModel.isPlaying = false
                            viewModel.presentEditingModeToastMessage()
                        }
                    }
                    MixpanelManager.shared.track(.watchPerformance(
                        [
                            "HowToCome": ComingPath.getPath(dependency.isAllFormationVisible).rawValue,
                            "hasTabbedFixSettingBtnf": "yes"
                        ]
                    ))
                } label: {
                    Image(viewModel.isTransitionEditable ? "fixsetting_on" : "fixsetting_off")
                }
                Rectangle().foregroundStyle(.clear).frame(height: 1)
                buildAllFormationButton()
                Spacer(minLength: 20)
                Button {
                    withAnimation {
                        viewModel.isSettingSheetVisible.toggle()
                    }
                } label: {
                    Image("setting")
                }
            }
            if viewModel.isPlaying {
                buildPuaseButton()
            } else {
                buildPlayButton()
            }
        }
        .padding(.top, 15)
        .padding(.horizontal, 24)
        .frame(height: 77)
        .background(Color.monoNormal1)
    }
    
    private func buildAllFormationButton() -> some View {
        Button {
            viewModel.isAllFormationVisible = true
        } label: {
            Image("showAllFormationButton")
        }
    }
    
    private func buildPlayButton() -> some View {
        Button {
            if !viewModel.isPlaying {
                viewModel.play()
            }
        } label: {
            Image("play_on")
        }
    }
    
    private func buildPuaseButton() -> some View {
        Button {
            if viewModel.isPlaying {
                viewModel.pause()
            }
        } label: {
            Image("play_off")
        }
    }
    
    private func buildSettingSheetView() -> some View {
        VStack(spacing: 14) {
            VStack(spacing: 14) {
                HStack {
                    Text("상세설정")
                    Spacer()
                    Button {
                        onDismissSettingSheet()
                    } label: {
                        Image("close")
                    }
                }
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                buildSectionView(label: "팀원 이름 보기", isOn: $viewModel.isNameVisiable)
                buildSectionView(label: "이전 동선 미리보기", isOn: $viewModel.isBeforeVisible)
                buildSectionView(label: "점선 보기", isOn: $viewModel.isLineVisible)
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
        }
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(hex: "212123"))
                .ignoresSafeArea(.all)
        }
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.visible)
    }
    
    private func buildSectionView(label: String, isOn: Binding<Bool>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.shadow(.inner(color: Color.monoBlack, radius: 10, y: 5)))
                .foregroundStyle(Color.monoNormal1)
                .frame(height: 46)
            HStack {
                Text(label)
                    .foregroundStyle(Color.monoWhite3)
                Spacer()
                Toggle("", isOn: isOn)
                    .tint(.blueNormal)
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                    Text("홈")
                }
                .foregroundColor(Color.blueLight3)
                .overlay(
                    isShowingSharedAlert ?
                    Color.build(hex: .modalBackground) :
                    Color.clear
                )

            }
        }
    }
    
    private func buildTitleItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Text("대형보기")
                .foregroundStyle(.white)
                .font(.body.weight(.bold))
                .overlay(
                    isShowingSharedAlert ?
                    Color.build(hex: .modalBackground) :
                    Color.clear
                )

        }
    }
    
    private func buildRightFixItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("수정") {
                guard let performance = viewModel.performance,
                      let copiedPerformance = try? DeepCopier.copy(performance.entity) else {
                    return
                }
                let dependency = FormationSettingViewDependency(
                    performance: copiedPerformance,
                    currentFormationIndex: viewModel.currentIndex,
                    isAutoUpdateDisabled: true
                )
                path.append(.formationSetting(dependency))
            }
            .overlay(
                isShowingSharedAlert ?
                Color.build(hex: .modalBackground) :
                Color.clear
            )

        }
    }
    
    private func buildRightSharedItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                animate(.interpolatingSpring) {
                    isShowingSharedAlert = true
                }
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14)
                    .offset(y: -1)
                    .overlay(
                        isShowingSharedAlert ?
                        Color.build(hex: .modalBackground) :
                        Color.clear
                    )

            }
        }
    }
    
    
    private func buildBackgroundView() -> some View {
        Image("background")
            .resizable()
            .ignoresSafeArea()
    }
    
    private func onDismissSettingSheet() {
        withAnimation {
            viewModel.isSettingSheetVisible = false
        }
    }
    
    private func onDismissAllFormationSheet() {
        viewModel.isAllFormationVisible = false
    }
}

extension PerformanceWatchingDetailView {
    enum ComingPath: String {
        case GeneratePerformanceYet
        case TabPerformanceCard
        
        static func getPath(_ isAutoShowAllForamation: Bool) -> ComingPath {
            if isAutoShowAllForamation {
                return .GeneratePerformanceYet
            } else {
                return .TabPerformanceCard
            }
        }
    }
}
