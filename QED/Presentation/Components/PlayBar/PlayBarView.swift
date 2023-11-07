//
//  PlayBarView.swift
//  QED
//
//  Created by chaekie on 11/3/23.
//

import SwiftUI
import UIKit

struct PlayBarView: View {
    @StateObject var viewModel: PerformanceWatchingDetailViewModel
    let formations: [Formation]
    @State private var playingSectionWidth = CGFloat.zero
    @State private var isLast = false
    @State private var formationCount = 0

    @Binding var scrollProxy: ScrollViewProxy?

    var body: some View {
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
                        .offset(x: viewModel.screenOffset)

                    }
                    .onAppear {
                        scrollProxy = proxy
                        UIScrollView.appearance().bounces = false
                        UIScrollView.appearance().decelerationRate  = .fast
                        playingSectionWidth = viewModel.previewWidth + viewModel.transitionWidth
                        formationCount = viewModel.performance.formations.count
                    }
                    .onPreferenceChange(ScrollOffsetKey.self) {
                            viewModel.offset = $0
                            viewModel.calculateScreenOffset()
                            viewModel.scrollViewDidScroll(offset: $0)
                            if viewModel.isScrollToExecuting {
                                viewModel.isScrollToExecuting = false
                            }
                            if playingSectionWidth > 0 {
                                viewModel.selectedIndex = Int(abs($0 / playingSectionWidth))
                            }
                    }
                    .onChange(of: viewModel.selectedIndex) {
                        if viewModel.isScrollingSlow && !viewModel.isScrollToExecuting {
                            HapticManager.shared.hapticImpact(style: .rigid)
                        }
                        isLast = $0 == formationCount - 1 ? true : false
                    }
                }

                buildCenterBarView()
            }
        }
        .frame(height: viewModel.previewHeight + 25)
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
                            index == viewModel.selectedIndex ? .green: .gray,
                            lineWidth: 1)
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
        TransitionShape()
            .stroke(index == viewModel.selectedIndex ? .green : .gray, lineWidth: 1.5)
            .frame(width: viewModel.transitionWidth, height: 35)
    }

    private func buildCenterBarView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.white)

            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(.blue, lineWidth: 1)
        }
        .frame(width: 4, height: 65)
        .offset(y: -4)
    }
}

private struct TransitionShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addQuadCurve(to: CGPoint(x: rect.width/2,
                                          y: rect.height/2),
                              control: CGPoint(x: rect.width/3,
                                               y: -rect.height/20))
            path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.height),
                              control: CGPoint(x: rect.width * 2/3,
                                               y: rect.height * 21/20))

            path.move(to: CGPoint(x: 0, y: rect.height))
            path.addQuadCurve(to: CGPoint(x: rect.width/2,
                                          y: rect.height/2),
                              control: CGPoint(x: rect.width/3,
                                               y: rect.height * 21/20 ))
            path.addQuadCurve(to: CGPoint(x: rect.width, y: 0),
                              control: CGPoint(x: rect.width * 2/3,
                                               y: -rect.height/20))
        }
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
    ), formations: mockFormations, scrollProxy: .constant(nil))
}
