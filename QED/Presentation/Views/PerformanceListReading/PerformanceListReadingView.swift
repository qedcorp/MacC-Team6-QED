//
//  PerformanceListReadingView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceListReadingView: View {
    @ObservedObject var viewModel: PerformanceListReadingViewModel
    @Binding var path: [PresentType]
    @Environment(\.dismiss) private var dismiss

    private let columns: [GridItem] = .init(repeating: .init(spacing: 16), count: 2)

    var body: some View {
        ZStack {
            if viewModel.performances.isEmpty {
                buildPerformanceListEmptyView()
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        buildPerformanceCountView()
                        buildPerformanceListView()
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .foregroundStyle(Color.monoWhite3)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            buildBackgroundView()
        )
        .navigationBarBackButtonHidden()
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            buildLeftItem()
            buildCenterItem()
        }
    }

    private func buildPerformanceCountView() -> some View {
        HStack {
            Text("전체(\(viewModel.performances.count))")
                .font(.headline.weight(.bold))
                .foregroundStyle(Color.monoWhite3)
            Spacer()
        }
        .padding(.top, 20)
    }

    private func buildPerformanceListView() -> some View {
        let performances = viewModel.performances
            .sorted { $0.createdAt > $1.createdAt }
        return LazyVGrid(columns: columns, alignment: .center, spacing: 24) {
            ForEach(Array(performances.enumerated()), id: \.offset) { (index, performance) in
                Button {
                    let nextPath = PerformanceRouter(performance: performance.entity).getItemPath()
                    path.append(nextPath)
                } label: {
                    PerformanceListCardView(
                        performance: performance.entity,
                        viewModel: viewModel,
                        isMyPerformance: true,
                        index: index,
                        onUpdate: viewModel.updatePerformanceTitle
                    )
                }
            }
        }
        .padding(.bottom, 40)
    }

    private func buildPerformanceListEmptyView() -> some View {
        Image("mainlistEmpty")
    }

    private func buildBackgroundView() -> some View {
        Image("background")
            .resizable()
            .ignoresSafeArea(.all)
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                path = []
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.blueLight3)
            }
        }
    }

    private func buildCenterItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Text("전체 프로젝트")
                .font(.body.weight(.bold))
                .foregroundStyle(Color.monoWhite3)
        }
    }
}
