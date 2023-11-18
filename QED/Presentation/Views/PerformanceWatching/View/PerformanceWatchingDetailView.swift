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
    @Binding var path: [PresentType]
    @StateObject private var viewModel = PerformanceWatchingDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var isTransitionEditable = false
    @State private var isToastVisiable = false
    @State private var isSheetVisiable = false
    @State private var isNameVisiable = true
    @State private var isBeforeVisible = true
    @State private var isLineVisible = false
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                buildTitleAndHeadcountView(geometry: geometry)
                VStack(spacing: 8) {
                    VStack {
                        buildMemo()
                        if isTransitionEditable {
                            buildMovementView(controller: viewModel.movementController, width: geometry.size.width - 48)
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
            .sheet(isPresented: $isSheetVisiable, onDismiss: onDismissSettingSheet) {
                buildSettingSheetView()
            }
            .sheet(isPresented: $viewModel.isAllFormationVisible, onDismiss: onDismissAllFormationSheet) {
                if let performance = viewModel.performance?.entity {
                    PerformanceWatchingListView(performance: performance,
                                                isAllFormationVisible: $viewModel.isAllFormationVisible,
                                                selectedIndex: $viewModel.selectedIndex
                    )
                }
            }
            .navigationBarBackButtonHidden()
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                buildLeftItem()
                buildTitleItem()
                buildRightItem()
            }
        }
        .overlay(
            viewModel.isZoomed ?
            buildZoomableView()
            : nil
        )
        .task {
            viewModel.setupWithDependency(dependency)
        }
        .onAppear {
            if viewModel.isAutoShowAllForamation {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.viewModel.isAllFormationVisible = true
                }
            }
        }
        .background {
            Image("background")
                .ignoresSafeArea()
        }
    }

    private func buildMovementView(controller: ObjectMovementAssigningViewController, width: CGFloat) -> some View {
        let height = width * CGFloat(12 / Float(19))
        return ZStack {
            if let beforeFormation = viewModel.beforeFormation,
               let afterFormation = viewModel.afterFormation {
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

    private func buildZoomableView() -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZoomableView {
                    buildMovementView(controller: viewModel.zoomableMovementController, width: geometry.size.width)
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
                tag: viewModel.currentFormationTag
            )
            Spacer()
            Button("Zoom") {
                viewModel.toggleZoom()
            }
        }
    }

    private func buildObjectPlayView() -> some View {
        ZStack {
            Image(isLineVisible ? "stage" : "stage_nongrid")
            if isLoading {
                ProgressView()
            }
            ObjectPlayableView(movementsMap: viewModel.movementsMap,
                               totalCount: viewModel.performance?.formations.count ?? 0,
                               offset: $viewModel.offset,
                               isShowingPreview: $isBeforeVisible,
                               isLoading: $isLoading,
                               isNameVisiable: $isNameVisiable
            )
        }
        .frame(height: 216)
    }

    private func onDismissSettingSheet() {
        isSheetVisiable = false
    }

    private func onDismissAllFormationSheet() {
        viewModel.isAllFormationVisible = false
    }

    private func buildTitleAndHeadcountView(geometry: GeometryProxy) -> some View {
        HStack {
            Text(viewModel.performance?.music.title ?? "")
                .bold()
                .lineLimit(1)
            Text("\(viewModel.performance?.headcount ?? 0)인")
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .font(.subheadline)
        .foregroundStyle(.gray)
        .padding(.horizontal, 20)
        .padding(.bottom, geometry.size.height * 0.1)
    }

    private func buildMemo() -> some View {
        let memo = viewModel.performance?.formations[safe: viewModel.selectedIndex]?.memo ?? "대형 \(viewModel.selectedIndex)"
        return ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.monoNormal1)
                .frame(height: 46)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(Gradient.strokeGlass3, lineWidth: 1)
                )

            Text("\(memo)")
                .foregroundStyle(Color.monoWhite3)
                .font(.title3)
        }
    }

    private func buildPlayerView() -> some View {
        ZStack {
            if let performance = viewModel.performance?.entity {
                GeometryReader { _ in
                    ScrollObservableView(performance: performance, action: viewModel.action)
                    buildAllFormationButton()
                }
                .frame(height: PlayBarConstants.playBarHeight + 25)
                if isToastVisiable {
                    buildToast()
                }
            }
        }
        .padding(.bottom)
    }

    private func buildTabBar(geometry: GeometryProxy) -> some View {
        HStack {
            Button {
                withAnimation(.spring) {
                    isTransitionEditable.toggle()
                    if isTransitionEditable {
                        isToastVisiable = true
                    }
                }
            } label: {
                Image(isTransitionEditable ? "fixsetting_on" : "fixsetting_off")
            }
            Spacer()
            if viewModel.isPlaying {
                buildPuaseButton()
            } else {
                buildPlayButton()
            }
            Spacer()
            Button {
                isSheetVisiable.toggle()
            } label: {
                Image("setting")
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
            Image("showAllFrames")
                .frame(height: PlayBarConstants.playBarHeight + 25)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 14))
        }
    }

    private func buildToast() -> some View {
        HStack {
            Image("sparkles")
            Text("동선추가 기능이 켜졌습니다")
        }
        .font(.headline)
        .bold()
        .padding()
        .foregroundColor(Color.monoWhite3)
        .background(.ultraThinMaterial)
        .background(Color.blueLight2)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeIn) {
                    isToastVisiable = false
                }
            }
        }
    }

    private func buildPlayButton() -> some View {
        Button {
            if !viewModel.isPlaying {
                viewModel.isPlaying = true
                viewModel.play()
            }
        } label: {
            Image("play_on")
        }
    }

    private func buildPuaseButton() -> some View {
        Button {
            if viewModel.isPlaying {
                viewModel.isPlaying = false
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
                .bold()
                .foregroundStyle(.white)
                buildSectionView(label: "팀원 이름 보기", isOn: $isNameVisiable)
                buildSectionView(label: "이전 동선 미리보기", isOn: $isBeforeVisible)
                buildSectionView(label: "점선 보기", isOn: $isLineVisible)
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
                .bold()
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
}
