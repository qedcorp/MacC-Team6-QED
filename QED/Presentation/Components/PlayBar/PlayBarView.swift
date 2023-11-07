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

    var body: some View {
        buildPlaybar()
    }

    private func buildPlaybar() -> some View {
        return HStack(spacing: 0) {
            ForEach(Array(zip(formations.indices, formations)), id: \.0) { index, formation in
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        buildPlayingSectionView(
                            index: index,
                            formation: formation
                        )
                        if index < formations.count - 1 {
                            buildTransitionView()
                        }
                    }
                    Text(formation.memo ?? "")
                        .font(.caption2)
                        .bold()
                        .foregroundStyle(index == viewModel.selectedIndex ? .green : .black)
                }
            }
        }
        .frame(height: 100)
    }

    private func buildPlayingSectionView(index: Int, formation: Formation) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 0) {
                DanceFormationView(
                    formation: formation,
                    index: index,
                    selectedIndex: viewModel.selectedIndex,
                    width: viewModel.previewWidth,
                    height: viewModel.previewHeight,
                    hideLine: true
                )
                .frame(width: viewModel.previewWidth, height: viewModel.previewHeight)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(
                            index == viewModel.selectedIndex ? .green: .gray,
                            lineWidth: 1)
                )
            }
        }
    }

    private func buildTransitionView() -> some View {
        TransitionShape()
            .stroke()
            .frame(width: viewModel.transitionWidth, height: 35)
            .offset(y: -8)
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
    ), formations: mockFormations)
}

// GeometryReader { geometry in
//            HStack(spacing: 0) {
//                ForEach(Array(zip(formations.indices, formations)), id: \.0) { index, formation in
//                    VStack(alignment: .leading) {
//                        HStack(spacing: 0) {
//                            buildPlayingSectionView(
//                                index: index,
//                                formation: formation
//                            )
//                            if index < formations.count - 1 {
//                                buildTransitionView()
//                            }
//                        }
//                        Text(formation.memo ?? "asdasdasdasd")
//                             .font(.caption2)
//                             .bold()
//                             .foregroundStyle(index == viewModel.selectedIndex ? .green : .black)
//                    }
//                }
//            }
//            .padding(.horizontal, geometry.size.width / 2)
//        }
//        .frame(height: viewModel.previewHeight + 25)
