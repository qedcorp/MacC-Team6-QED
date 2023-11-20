//
//  PerformanceWatchingListView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import Combine
import SwiftUI

struct PerformanceWatchingListView: View {
    typealias ValuePurpose = ScrollObservableView.ValuePurpose

    @Binding var isAllFormationVisible: Bool
    var selectedIndex: Int
    var action: CurrentValueSubject<ValuePurpose, Never>
    var performance: Performance

    init(performance: Performance,
         isAllFormationVisible: Binding<Bool>,
         selecteIndex: Int,
         action: CurrentValueSubject<ValuePurpose, Never>) {

        self.performance = performance
        self._isAllFormationVisible = isAllFormationVisible
        self.selectedIndex = selecteIndex
        self.action = action
    }

    var body: some View {
        ZStack {
            Color.monoBlack.ignoresSafeArea(.all)
            VStack(spacing: 30) {
                buildHeaderView()
                buildPerformanceScrollView()
            }
            .padding(24)
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
                                    selectedIndex: selectedIndex,
                                    width: 163,
                                    height: 123
                                )
                                .onTapGesture {
                                    action.send(.setSelctedIndex(rowIndex + columnIndex))
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
