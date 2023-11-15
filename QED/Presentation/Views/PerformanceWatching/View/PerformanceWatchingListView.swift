//
//  PerformanceWatchingListView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceWatchingListView: View {
    @Binding var selectedIndex: Int
    @Binding var isAllFormationVisible: Bool
    var performance: Performance

    init(performance: Performance,
         isAllFormationVisible: Binding<Bool>,
         selectedIndex: Binding<Int>) {

        self.performance = performance
        self._isAllFormationVisible = isAllFormationVisible
        self._selectedIndex = selectedIndex
        print(selectedIndex)
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
            Button {
                isAllFormationVisible = false
            } label: {
                Image("close")
            }
        }
    }

    private func buildPerformanceScrollView() -> some View {
        let formations = performance.formations
        let chunkNumber = 2

        return ScrollView {
            Grid {
                ForEach(Array(
                    stride(from: 0, to: formations.count, by: chunkNumber)
                ), id: \.self) { rowIndex in
                    HStack {
                        ForEach(0..<chunkNumber, id: \.self) { columnIndex in
                            if rowIndex + columnIndex < formations.count {
                                DanceFormationView(
                                    formation: formations[rowIndex + columnIndex],
                                    index: rowIndex + columnIndex,
                                    width: 163,
                                    height: 123
                                )
                                .onTapGesture {
                                    selectedIndex = rowIndex + columnIndex
                                    isAllFormationVisible = false
                                }

                            }
                            Spacer()
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
