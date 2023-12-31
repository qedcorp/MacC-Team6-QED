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
            Color(hex: "212123").ignoresSafeArea(.all)
            VStack(spacing: 0) {
                buildHeaderView()
                buildPerformanceScrollView()
            }
        }
        .presentationDragIndicator(.visible)
    }

    private let columns: [GridItem] = [
        GridItem(spacing: 16, alignment: nil),
        GridItem(spacing: 16, alignment: nil)
    ]

    private func buildHeaderView() -> some View {
        HStack {
            Text("전체 대형 보기")
                .fontWeight(.bold)
                .font(.title3)
                .foregroundStyle(Color.monoWhite3)
            Spacer()
            Button {
                isAllFormationVisible = false
            } label: {
                Image("close")
            }
        }
        .padding(24)
    }

    private func buildPerformanceScrollView() -> some View {
        let formations = performance.formations

        return ScrollView {
            LazyVGrid(columns: columns,
                      alignment: .center,
                      spacing: 10,
                      pinnedViews: .sectionHeaders) {
                ForEach(Array(formations.enumerated()), id: \.offset) { (index, _) in
                    DanceFormationView(
                        formation: formations[index],
                        index: index,
                        selectedIndex: selectedIndex
                    )
                    .onTapGesture {
                        action.send(.setSelectedIndex(index))
                        isAllFormationVisible = false
                    }
                }
            }
                      .padding(.horizontal, 24)
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
