//
//  PerformanceWatchingListView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceWatchingListView: View {
    @ObservedObject private var viewModel: PerformanceWatchingListViewModel
    @Environment(\.dismiss) private var dismiss
    @State var isNameVisible = false
    @State var isEditMode = false

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
        VStack(spacing: 15) {
            titleAndHeadcount
            TogglingMemberNameView(isNameVisible: $isNameVisible)
            PerformanceScrollView(viewModel: viewModel,
                                  isNameVisible: isNameVisible,
                                  isEditMode: isEditMode)
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
            Text("\(viewModel.performance.music.title)")
                .bold()
                .lineLimit(1)
            Text("\(viewModel.performance.headcount)인")
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
                    isEditMode.toggle()
                }
            } label: {
                Text(isEditMode ? "완료" : "수정")
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
    @StateObject var viewModel: PerformanceWatchingListViewModel
//    let performanceUseCase = DefaultPerformanceUseCase(
//        performanceRepository: MockPerformanceRepository(),
//        userStore: DefaultUserStore.shared
//    )
    var isNameVisible: Bool
    var isEditMode: Bool
    @State private var selectedIndex: Int?

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(Array(zip(viewModel.performance.formations.indices, viewModel.performanceSettingManager.performance.formations)), id: \.1) { index, formation in
                    VStack {
                        DanceFormationPreview(
                            viewModel: viewModel,
                            formation: formation,
                            index: index,
                            selectedIndex: $selectedIndex,
                            isNameVisible: isNameVisible
                        )
                        if isEditMode {
                            HStack(spacing: 20) {
                                DeleteButton(viewModel: viewModel,
                                             index: index)
                                AddButton(viewModel: viewModel)
                            }
                            .padding(.bottom, 15)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct AddButton: View {
    @StateObject var viewModel: PerformanceWatchingListViewModel

    var body: some View {
        NavigationLink {
            FormationSettingView(
                performance: viewModel.performanceSettingManager.performance,
                performanceUseCase: viewModel.performanceUseCase
            )
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("추가하기")
            }
            .bold()
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .foregroundStyle(.green)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

private struct DeleteButton: View {
    @StateObject var viewModel: PerformanceWatchingListViewModel
    let index: Int

    var body: some View {
        Button {
            viewModel.removeFormation(index: index)
        } label: {
            HStack {
                Image(systemName: "trash")
                Text("삭제하기")
            }
            .bold()
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .foregroundStyle(.red)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

private struct DanceFormationPreview: View {
    @StateObject var viewModel: PerformanceWatchingListViewModel
    let formation: Formation
    let index: Int
    @Binding var selectedIndex: Int?
    let isNameVisible: Bool

    var body: some View {
        NavigationLink(destination: PerformanceWatchingDetailView(
            viewModel: PerformanceWatchingDetailViewModel(
                performance: viewModel.performanceSettingManager.performance
            ), index: index)) {
                    DanceFormationView(
                        formation: formation,
                        index: index,
                        isNameVisible: isNameVisible
                    )
                    .frame(height: 250)
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
