//
//  WatchingPerformanceWatchingDetailView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct PerformanceWatchingDetailView: View {

    typealias PlayBarConstants = ScrollObservableView.Constants
    @Environment(\.dismiss) private var dismiss

    @StateObject var viewModel: PerformanceWatichingDetailViewModel

    @State private var isTransitionEditable = false
    @State private var isToastVisiable = false

    @State private var isAllFormationVisible = false
    @State private var isSheetVisiable = false
    @State private var isNameVisiable = false
    @State private var isBeforeVisible = false
    @State private var isLineVisible = false
    @State private var isPlaying = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                buildTitleAndHeadcountView(geometry: geometry)
                VStack(spacing: 8) {
                    VStack {
                        buildMemo()
                        buildObjectPlayView()
                        if isTransitionEditable {
                            buildDetailControlButtons()
                        }
                    }
                    .padding(.horizontal, 24)
                }
                Spacer()
                buildPlayerView()
                buildTabBar(geometry: geometry)
            }
            .background(.black)
            .sheet(isPresented: $isSheetVisiable, onDismiss: onDismissSettingSheet) {
                buildSettingSheetView()
            }
            .sheet(isPresented: $isAllFormationVisible, onDismiss: onDismissAllFormationSheet, content: {
                VStack {}
            })
            .navigationBarBackButtonHidden()
            .navigationTitle(viewModel.performance.title ?? "")
            .toolbar {
                buildLeftItem()
                buildRightItem()
            }
        }
    }

    private func buildObjectPlayView() -> some View {
        ObjectPlayableView(movementsMap: viewModel.movementsMap,
                           totalCount: viewModel.performance.formations.count,
                           offset: $viewModel.offset,
                           isShowingPreview: $viewModel.isShowingPreview
        )
        .frame(height: 216)
    }

    private func onDismissSettingSheet() {
        isSheetVisiable = false
    }

    private func onDismissAllFormationSheet() {
        isAllFormationVisible = false
    }

    private func buildTitleAndHeadcountView(geometry: GeometryProxy) -> some View {
        HStack {
            Text("\(viewModel.performance.music.title)")
                .bold()
                .lineLimit(1)
            Text("\(viewModel.performance.headcount)인")
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
        let memo = viewModel.performance.formations[viewModel.selectedIndex].memo ?? "대형 \(viewModel.selectedIndex)"
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

    private func buildDetailControlButtons() -> some View {
        HStack {
            buildUndoButton()
            buildRedoButton()
            Spacer()
            buildZoomInButton()
        }
        .padding(.horizontal, 25)
    }

    private func buildUndoButton() -> some View {
        Button {} label: {
            Image("back_off")
        }
    }

    private func buildRedoButton() -> some View {
        Button {} label: {
            Image("forward_off")
        }
    }

    private func buildZoomInButton() -> some View {
        Button {
            //  TODO: 확대 기능
        } label: {
            Image("zoom_off")
        }
    }

    private func buildPlayerView() -> some View {
        ZStack {
            GeometryReader { _ in
                ScrollObservableView(performance: viewModel.performance, action: viewModel.action)
                buildAllFormationButton()
            }
            .frame(height: PlayBarConstants.playBarHeight + 25)
            if isToastVisiable {
                buildToast()
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
            if isPlaying {
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
            isAllFormationVisible = true
        } label: {
            Image("showAllFrames")
                .frame(height: PlayBarConstants.playBarHeight + 25)
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 14))
        }
        .background(Color.monoBlack)
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
            isPlaying = true
            viewModel.play()
        } label: {
            Image("play_on")
        }
    }

    private func buildPuaseButton() -> some View {
        Button {
            isPlaying = false
            viewModel.pause()
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
                buildSectionView(label: "다음 동선 미리보기", isOn: $isBeforeVisible)
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

    private func buildRightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                //  TODO: 상세 동선 수정 기능
            } label: {
                Text("수정")
                    .foregroundStyle(Color.blueLight3)
            }
        }
    }
}
