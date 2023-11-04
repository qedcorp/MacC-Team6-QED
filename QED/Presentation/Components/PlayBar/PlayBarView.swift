//
//  PlayBarView.swift
//  QED
//
//  Created by chaekie on 11/3/23.
//

import SwiftUI

struct PlayBarView: View {
    @StateObject var viewModel: PerformanceWatchingDetailViewModel
    let formations: [Formation]
    @State private var playingSectionWidth = CGFloat.zero
    @State private var isLast = false
    @State private var formationCount = 0

    var body: some View {
        VStack {
            Text("\(viewModel.offset)")
            GeometryReader { geometry in
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            buildScrollObservableView()
                            HStack(spacing: 0) {
                                ForEach(Array(zip(formations.indices, formations)),
                                        id: \.0) { index, formation in
                                    buildPlayingSectionView(
                                        index: index,
                                        formation: formation,
                                        proxy: proxy
                                    )
                                }
                            }
                            .padding(.horizontal, geometry.size.width / 2)
                            .offset(x: calculateOffset())
                        }
                        .onPreferenceChange(ScrollOffsetKey.self) {
                            viewModel.setOffset($0)
                        }
                        .onAppear {
                            UIScrollView.appearance().bounces = false
                            playingSectionWidth = viewModel.previewWidth + viewModel.transitionWidth
                            formationCount = viewModel.performance.formations.count
                        }
                        .onChange(of: viewModel.offset, perform: {
                            if viewModel.isScrolling {
                                viewModel.isScrolling = false
                            }
                            viewModel.selectedIndex = Int(abs($0 / playingSectionWidth))
                        })
                        .onChange(of: viewModel.selectedIndex) {
                            isLast = $0 == formationCount - 1 ? true : false
                        }
                    }
                    Rectangle()
                        .frame(width: 4, height: viewModel.previewHeight)
                        .offset(y: -6)
                }
                .frame(height: viewModel.previewHeight + 25)
                .background(.purple)
            }

        }
    }

    private func calculateOffset() -> CGFloat {
        guard viewModel.isScrolling else { return .zero }
        if isLast {
            return -viewModel.previewWidth / 2
        } else {
            return -playingSectionWidth / 2
        }
    }

    private func buildScrollObservableView() -> some View {
        GeometryReader { proxy in
            let offsetX = proxy.frame(in: .global).origin.x
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetX
                )
        }
    }

    private func buildPlayingSectionView(index: Int, formation: Formation, proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 0) {
                DanceFormationView(
                    formation: formation,
                    index: index,
                    hideLine: true
                )
                .frame(width: viewModel.previewWidth, height: viewModel.previewHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(
                            index == viewModel.selectedIndex ? .green: .clear,
                            lineWidth: 2)
                )
                if index != formationCount - 1 {
                    buildTransitionView(index: index)
                }
            }

            Text(formation.memo ?? "")
                .font(.caption2)
                .bold()
                .foregroundStyle(index == viewModel.selectedIndex ? .green : .black)
        }
        .onTapGesture {
            proxy.scrollTo(index, anchor: .center)
            viewModel.selectFormation(selectedIndex: index)
        }
    }

    private func buildTransitionView(index: Int) -> some View {
        Rectangle()
            .frame(width: viewModel.transitionWidth, height: 35)
            .foregroundStyle(index == viewModel.selectedIndex ? .green : .gray)
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    PlayBarView(viewModel: PerformanceWatchingDetailViewModel(
        performance: mockPerformance3
    ), formations: mockFormations)
}
