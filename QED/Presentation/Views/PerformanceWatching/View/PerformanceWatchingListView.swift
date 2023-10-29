//
//  PerformanceWatchingListView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceWatchingListView: View {
    let performance: Performance
    @Environment(\.dismiss) private var dismiss
    @State var isNameVisible = false
    @State var isAddVisible = false

    var body: some View {
        VStack(spacing: 15) {
            titleAndHeadcount
            TogglingMemberNameView(isNameVisible: $isNameVisible)
            PerformanceScrollView(performance: performance,
                                  isNameVisible: isNameVisible,
                                  isAddVisible: isAddVisible)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("전체 대형 보기")
        .toolbar {
            leftItem
            rightItem
        }
    }

    private var titleAndHeadcount: some View {
        HStack {
            if let title = performance.title {
                Text("\(title)")
                    .bold()
                    .lineLimit(1)
            }
            Text("\(performance.headcount)인")
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .font(.subheadline)
        .foregroundStyle(.gray)
        .padding(.horizontal, 20)
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation(.easeIn(duration: 0.3)) {
                    isAddVisible.toggle()
                }
            } label: {
                Text(isAddVisible ? "완료" : "추가")
                    .foregroundStyle(.green)
            }
        }
    }
}

private struct TogglingMemberNameView: View {
    @Binding var isNameVisible: Bool

    var body: some View {
        HStack {
            Text("팀원 이름 보기")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .foregroundStyle(isNameVisible ? .gray: .black)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            toggleButton
            Spacer()
        }
        .bold()
        .font(.subheadline)
        .padding(.horizontal, 20)
    }

    private var toggleButton: some View {
        Button {
            withAnimation(.bouncy(duration: 0.15)) {
                isNameVisible.toggle()
            }
        } label: {
            Text(isNameVisible ? "off" : "on")
                .foregroundStyle(.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

}

private struct PerformanceScrollView: View {
    private let performanceUseCase = DefaultPerformanceUseCase(
        performanceRepository: MockPerformanceRepository(),
        userStore: DefaultUserStore.shared)
    let performance: Performance
    var isNameVisible: Bool
    var isAddVisible: Bool
    @State private var selectedIndex: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(Array(zip(performance.formations.indices, performance.formations)), id: \.1) { index, formation in
                    ZStack {
                        deleteButton
                        DanceFormationPreview(
                            performance: performance,
                            formation: formation,
                            index: index,
                            selectedIndex: $selectedIndex,
                            isNameVisible: isNameVisible
                        )

                        if isAddVisible {
                            addButton
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .gesture(scroll)
    }

    private var scroll: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.translation.height != 0 {
                    selectedIndex = nil
                }
            }
    }

    private var deleteButton: some View {
        HStack {
            Spacer()
            Button {
                //     TODO: 삭제
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.white)
                    .font(.title2)
                    .padding()
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal)
    }

    private var addButton: some View {
        NavigationLink {
            FormationSetupView(performanceUseCase: performanceUseCase,
                               performance: performance)
        } label: {
            ZStack {
                Circle()
                    .fill(.green)
                    .frame(width: 40, height: 40)
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .bold()
            }
        }

    }
}

private struct DanceFormationPreview: View {
    let performance: Performance
    let formation: Formation
    let index: Int
    @Binding var selectedIndex: Int?
    let isNameVisible: Bool
    @State private var draggedOffsetX = CGFloat.zero
    @State private var accumulatedOffsetX = CGFloat.zero
    private let defaultSwipeX = CGFloat(90)

    var body: some View {
        NavigationLink(destination: PerformanceWatchingDetailView(
            viewModel: PerformanceWatchingDetailViewModel(
                performance: performance), index: index)) {
                    DanceFormationView(
                        formation: formation,
                        index: index,
                        isNameVisible: isNameVisible
                    )
                    .frame(height: 250)
                    .offset(x: draggedOffsetX)
                    .gesture(swipeToDelete)
                    .onChange(of: selectedIndex) { index in
                        if self.index != index {
                            withAnimation(.spring(duration: 0.3)) {
                                draggedOffsetX = 0
                                accumulatedOffsetX = 0
                            }
                        }
                    }
                }
    }

    private var swipeToDelete: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if abs(gesture.translation.height) > 50 {
                    selectedIndex = nil
                } else {
                    if gesture.translation.width != 0 {
                        selectedIndex = index
                    }
                    if gesture.translation.width < 0 {
                        draggedOffsetX = max(accumulatedOffsetX + gesture.translation.width, -defaultSwipeX * 2)
                    } else if accumulatedOffsetX < 0 {
                        draggedOffsetX = min(accumulatedOffsetX + gesture.translation.width, defaultSwipeX)
                    }
                }
            }
            .onEnded { gesture in
                withAnimation(.spring(duration: 0.3)) {
                    if gesture.translation.width < -defaultSwipeX / 2 {
                        draggedOffsetX = -defaultSwipeX
                        accumulatedOffsetX = -defaultSwipeX
                    } else if gesture.translation.width > defaultSwipeX / 2 {
                        draggedOffsetX = 0
                        accumulatedOffsetX = 0
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

fileprivate extension CGSize {
    static func + (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width + rhs.width,
               height: lhs.height + rhs.height)
    }

    static func - (lhs: Self, rhs: Self) -> Self {
        CGSize(width: lhs.width - rhs.width,
               height: lhs.height - rhs.height)
    }

    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}

#Preview {
    PerformanceWatchingListView(performance: mockPerformance1)
}
