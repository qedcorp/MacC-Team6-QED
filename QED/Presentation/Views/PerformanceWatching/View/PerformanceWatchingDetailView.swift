//
//  WatchingPerformanceWatchingDetailView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct PerformanceWatchingDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: PerformanceWatchingDetailViewModel
    var index: Int
    @State private var isTransitionEditable = false
    @State private var isToastVisiable = false

    @State private var isAllFormationVisible = false

    @State private var isPlaying = false

    @State private var isSheetVisiable = false
    @State private var isNameVisiable = false
    @State private var isBeforeVisible = false
    @State private var isLineVisible = false

    @State private var formationCount = 0
    @State private var totalWidth = CGFloat.zero
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack(spacing: 10) {
            PlayableDanceFormationView(viewModel: viewModel)
            if isTransitionEditable {
                buildDetailControlButtons()
            }
            Spacer()
            buildPlayerView()
            buildTabBar()
        }
        .background(Color.monoBlack)
        .sheet(isPresented: $isSheetVisiable, onDismiss: onDismissSheet) {
            buildSettingSheetView()
        }
        .onAppear {
            viewModel.selectedIndex = index
            formationCount = viewModel.performance.formations.count
            totalWidth = (
                viewModel.previewWidth + viewModel.transitionWidth
            ) * CGFloat(formationCount) - viewModel.transitionWidth
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(viewModel.performance.title ?? "")
        .toolbar {
            buildLeftItem()
            buildRightItem()
        }
    }

    private func onDismissSheet() {
        isSheetVisiable = false
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
                PlayBarView(
                    viewModel: viewModel,
                    formations: viewModel.performance.formations,
                    scrollProxy: $scrollProxy
                )

                buildAllFormationButton()
            }
            .frame(height: viewModel.previewHeight + 25)

            if isToastVisiable {
                buildToast()
            }
        }

    }

    private func buildTabBar() -> some View {
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
            buildPlayButton()
            Spacer()
            Button {
                isSheetVisiable.toggle()
            } label: {
                Image("setting")
            }
        }
        .padding(.horizontal, 24)
        .frame(height: 123)
        .background(Color.monoNormal1)
    }

    private func buildAllFormationButton() -> some View {
        Button {
            isAllFormationVisible = true
        } label: {
            Image("showAllFrames")
                .frame(height: viewModel.previewHeight + 25)
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
        let remainingWidth = totalWidth + viewModel.offset
        let remainingCount = formationCount - viewModel.selectedIndex

        return Button {
            isPlaying.toggle()
            if isPlaying {
                if viewModel.selectedIndex == formationCount - 1 {
                    viewModel.selectedIndex = 0
                } else {
                    viewModel.play()
                }
            } else {
                viewModel.pause()
            }
        } label: {
            Image("play_on")
        }
    }

    private func buildMoveToFirstButton() -> some View {
        Button {
            viewModel.selectFormation(selectedIndex: 0)
            scrollProxy?.scrollTo(0, anchor: .center)
        } label: {
            Image(systemName: "chevron.left")
        }
    }

    private func buildMoveToLastButton() -> some View {
        Button {
            viewModel.selectFormation(selectedIndex: formationCount - 1)
            scrollProxy?.scrollTo(formationCount - 1, anchor: .center)
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
                        onDismissSheet()
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

#Preview {
    PerformanceWatchingDetailView(viewModel: PerformanceWatchingDetailViewModel(
        performance: mockPerformance1
    ), index: 0)
}
