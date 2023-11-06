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
    @State private var isNameVisiable = false
    @State private var isBeforeVisible = false
    @State private var isPlaying = false

    @State private var formationCount = 0
    @State private var totalWidth = CGFloat.zero
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack(spacing: 10) {
            PlayableDanceFormationView(viewModel: viewModel)
            buildDetailControlButtons()
            PlayBarView(viewModel: viewModel,
                        formations: viewModel.performance.formations,
                        scrollProxy: $scrollProxy)
            Spacer()
            buildPlayButtons()
            Spacer()
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
            //            buildRightItem()
        }
    }

    private func buildDetailControlButtons() -> some View {
        HStack {
            HStack {
                Text("이전 동선 미리보기")
                    .foregroundStyle(isBeforeVisible ? .gray : .black)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                buildBeforeFormationButton()
                //                buildZoomInButton()
            }
            .bold()
            Spacer()

        }
        .font(.subheadline)
        .padding(.bottom, 10)
        .padding(.horizontal, 20)
    }

    private func buildBeforeFormationButton() -> some View {
        Button {
            isBeforeVisible.toggle()
            viewModel.beforeFormationShowingToggle()
        } label: {
            Text(isBeforeVisible ? "off" : "on")
                .foregroundStyle(isBeforeVisible ? .gray : .green)
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    private func buildZoomInButton() -> some View {
        Button {
            //  TODO: 확대 기능
        } label: {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .padding(5)
                .background(Color(.systemGray5))
                .foregroundStyle(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    private func buildPlayButtons() -> some View {
        HStack(spacing: 50) {
            buildMoveToFirstButton()
            buildPlayButton()
            buildMoveToLastButton()
        }
        .foregroundColor(.green)
        .font(.title2)
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
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title)
        }
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private func buildRightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                //  TODO: 상세 동선 수정 기능
            } label: {
                Text("동선수정")
                    .foregroundStyle(.green)
            }
        }
    }
}

#Preview {
    PerformanceWatchingDetailView(viewModel: PerformanceWatchingDetailViewModel(
        performance: mockPerformance1
    ), index: 0)
}
