//
//  WatchingPerformanceWatchingDetailView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct PerformanceWatchingDetailView: View {
    typealias PlayBarConstants = ScrollObservableView.Constants

    let dependency: PerformanceWatchingViewDependency
    @Binding var path: [PresentType]
    @StateObject private var viewModel = PerformanceWatchingDetailViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if let performance = viewModel.performance {
                    MusicHeadcountView(title: performance.music.title,
                                       headcount: performance.headcount)
                    .padding(.bottom, geometry.size.height * 0.1)
                }
                VStack(spacing: 8) {
                    VStack {
                        buildMemo()
                        if viewModel.isTransitionEditable {
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
                }
                Spacer()
                buildPlayerView()
                buildTabBar(geometry: geometry)
            }
        }
        .background {
            Image("background")
                .ignoresSafeArea()
        }
        .overlay(
            viewModel.isZoomed ?
            buildZoomableMovementEditingView()
            : nil
        )
        .navigationBarBackButtonHidden()
        .toolbar(viewModel.isNavigationBarHidden ? .hidden : .visible, for: .navigationBar)
        .toolbar {
            buildLeftItem()
            buildTitleItem()
            buildRightItem()
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
            }
        }
        .sheet(isPresented: $viewModel.isSettingSheetVisible, onDismiss: onDismissSettingSheet) {
            buildSettingSheetView()
        }
        .sheet(isPresented: $viewModel.isAllFormationVisible, onDismiss: onDismissAllFormationSheet) {
            if let performance = viewModel.performance?.entity {
                PerformanceWatchingListView(performance: performance,
                                            isAllFormationVisible: $viewModel.isAllFormationVisible,
                                            selecteIndex: viewModel.selectedIndex,
                                            action: viewModel.action
                )
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
        }
    }

    private func buildPlayerView() -> some View {
        ZStack {
            if let performance = viewModel.performance?.entity {
                ScrollObservableView(performance: performance,
                                     action: viewModel.action
                ).frame(height: PlayBarConstants.playBarHeight)
            }
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
                                viewModel.action.send(.setSelctedIndex(1))
                            }
                            viewModel.isPlaying = false
                            viewModel.presentEditingModeToastMessage()
                        }
                    }
                } label: {
                    Image(viewModel.isTransitionEditable ? "fixsetting_on" : "fixsetting_off")
                }
                Rectangle().foregroundStyle(.clear).frame(height: 1)
                buildAllFormationButton()
                Spacer(minLength: 20)
                Button {
                    viewModel.isSettingSheetVisible.toggle()
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
        .padding(.horizontal, 24)
        .frame(height: geometry.size.height * 0.15)
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

    private func buildMoveToFirstButton() -> some View {
        Button {

        } label: {
            Image(systemName: "chevron.left")
        }
    }

    private func buildMoveToLastButton() -> some View {
        Button {

        } label: {
            Image(systemName: "chevron.right")
        }
    }

    private func buildSettingSheetView() -> some View {
        ZStack {
            Color.monoBlack.ignoresSafeArea(.all)
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
            .padding(.horizontal, 24)
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
                Button {
                    isOn.wrappedValue.toggle()
                } label: {
                    Image(isOn.wrappedValue ? "toggle_on" : "toggle_off")
                }
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
                    Text("홈")
                }
                .foregroundColor(Color.blueLight3)
            }
        }
    }

    private func buildTitleItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Text("대형보기")
                .foregroundStyle(.white)
                .fontWeight(.heavy)
        }
    }

    private func buildRightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Text("수정")
                .foregroundStyle(Color.blueLight3)
                .onTapGesture {
                    guard let performance = viewModel.performance?.entity else {
                        return
                    }
                    let dependency = FormationSettingViewDependency(
                        performance: performance,
                        currentFormationIndex: viewModel.currentIndex
                    )
                    path.append(.formationSetting(dependency))
                }
        }
    }

    private func onDismissSettingSheet() {
        viewModel.isSettingSheetVisible = false
    }

    private func onDismissAllFormationSheet() {
        viewModel.isAllFormationVisible = false
    }
}
