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
    @State private var scrollPadding = CGFloat.zero

    var body: some View {
        VStack {
            Text("\(viewModel.offset)")
            GeometryReader { geometry in
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal) {
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
                            .padding(.horizontal, scrollPadding)
                        }
                        .onPreferenceChange(ScrollOffsetKey.self) {
                            viewModel.setOffset($0)
                        }
                        .onAppear {
                            UIScrollView.appearance().bounces = false
                            scrollPadding = geometry.size.width / 2
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

    private func buildScrollObservableView() -> some View {
        GeometryReader { proxy in
            let offsetX = proxy.frame(in: .global).origin.x
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetX
                )
                .onAppear {
                    viewModel.setOriginOffset(offsetX)
                }
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
                            viewModel.selectedIndex == index ? .green: .clear,
                            lineWidth: 2)
                )
                if index != viewModel.totalLength - 1 {
                    Rectangle()
                        .frame(width: viewModel.pauseWidth, height: 35)
                        .foregroundStyle(index == viewModel.selectedIndex ? .green : .gray)
                }
            }

            Text(formation.memo ?? "")
                .font(.caption2)
                .bold()
                .foregroundStyle(index == viewModel.selectedIndex ? .green : .black)
        }
        .onTapGesture {
            proxy.scrollTo(index, anchor: .leading)
            viewModel.selectFormation(selectedIndex: index)
        }
        .onChange(of: viewModel.offset, perform: { _ in
            //              scrollPadding += (viewModel.previewWidth + viewModel.pauseWidth) / 2
//            let totalWidth = viewModel.previewWidth + viewModel.pauseWidth
//            viewModel.selectedIndex = Int(abs(viewModel.offset / totalWidth))
        })
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
