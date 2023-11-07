//
//  PerformanceWatchingListView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceWatchingListView: View {
    @ObservedObject private var viewModel: PerformanceWatchingListViewModel

    init(performance: Performance,
         performanceUseCase: PerformanceUseCase) {
        let performanceSettingManager = PerformanceSettingManager(
            performance: performance,
            performanceUseCase: performanceUseCase
        )

        self.viewModel = PerformanceWatchingListViewModel(
            performanceSettingManager: performanceSettingManager,
            performanceUseCase: performanceUseCase
        )
    }

    var body: some View {
        ZStack {
            Color.monoBlack.ignoresSafeArea(.all)
            VStack(spacing: 30) {
                buildHeaderView()
                buildPerformanceScrollView()
            }
            .padding(.horizontal, 24)
        }
        .presentationDragIndicator(.visible)
    }

    private func buildHeaderView() -> some View {
        HStack {
            Text("전체 대형 보기")
                .bold()
                .font(.title3)
                .foregroundStyle(Color.monoWhite3)
            Spacer()
            Button {} label: {
                Image("close")
            }
        }
    }

    private func buildPerformanceScrollView() -> some View {
        @State var selectedIndex: Int?
        let formations = viewModel.performanceSettingManager.performance.formations
        let chunkNumber = 2

        return ScrollView {
            Grid {
                ForEach(Array(
                    stride(from: 0, to: formations.count, by: chunkNumber)
                ), id: \.self) { rowIndex in
                    GridRow {
                        ForEach(0..<chunkNumber, id: \.self) { columnIndex in
                            if rowIndex + columnIndex < formations.count - 1 {
                                DanceFormationView(
                                    formation: formations[rowIndex + columnIndex],
                                    index: rowIndex + columnIndex,
                                    width: 163,
                                    height: 123
                                )
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}

extension Formation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Formation, rhs: Formation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
