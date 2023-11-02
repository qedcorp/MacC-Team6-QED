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
            buildTitleAndHeadcountView()
            buildMemberNameView()
            buildPerformanceScrollView()
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("전체 대형 보기")
        .toolbar {
            buildLeftItem()
            buildRightItem()
        }
    }

    private func buildTitleAndHeadcountView() -> some View {
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

    private func buildMemberNameView() -> some View {
        HStack {
            Text("팀원 이름 보기")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .foregroundStyle(isNameVisible ? .gray: .black)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            buildMemberNameToggleButton()
            Spacer()
        }
        .bold()
        .font(.subheadline)
        .padding(.horizontal, 20)
    }

    private func buildMemberNameToggleButton() -> some View {
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

    private func buildPerformanceScrollView() -> some View {
        @State var selectedIndex: Int?

        return ScrollView {
            VStack(spacing: 30) {
                ForEach(Array(zip(viewModel.performance.formations.indices, viewModel.performanceSettingManager.performance.formations)), id: \.1) { index, formation in
                    VStack {
                        buildDanceFormationPreview(formation: formation, index: index)
                        if isEditMode {
                            HStack(spacing: 20) {
                                buildDeleteFormationButton(index: index)
                                buildAddFormationButton()
                            }
                            .padding(.bottom, 15)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private func buildDanceFormationPreview(formation: Formation, index: Int) -> some View {
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

    private func buildAddFormationButton() -> some View {
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

    private func buildDeleteFormationButton(index: Int) -> some View {
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

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private func buildRightItem() -> ToolbarItem<(), some View> {
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

extension Formation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Formation, rhs: Formation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
