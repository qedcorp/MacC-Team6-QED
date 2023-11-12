//
//  PerformanceListReadingView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceListReadingView: View {
    @StateObject private var viewModel = MainViewModel(
        performanceUseCase: DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    )
    @Environment(\.dismiss) private var dismiss

    let columns: [GridItem] = [
        GridItem(spacing: 0, alignment: nil),
        GridItem(spacing: 0, alignment: nil)]

    var body: some View {
        VStack {
            subline
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 25) {
                    ForEach(viewModel.myRecentPerformances) { performance in
                        NavigationLink {
                            PerformanceWatchingListView(performance: performance.entity,
                                                        performanceUseCase: viewModel.performanceUseCase)
                        } label: {
                            PerformanceListCardView(performance: performance)
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        .background(
            Image("background")
                .resizable()
                .ignoresSafeArea(.all)
        )
        .onAppear {
            viewModel.fetchMyRecentPerformances()
        }
        .foregroundStyle(Color.monoWhite3)
        .navigationBarBackButtonHidden()
        .toolbar {
            leftItem
            ToolbarItem(placement: .principal) {
                Text("제작한 프로젝트")
                    .font(.body)
                    .bold()
                    .foregroundStyle(Color.monoWhite3)
            }
        }
    }

    private var subline: some View {
        HStack {
            // TODO: 퍼포먼스 갯수 가져오기
            Text("전체( )")
                .font(.headline)
                .bold()
                .foregroundStyle(Color.monoWhite3)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 25)
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.blueLight3)
            }
        }
    }
}

#Preview {
    PerformanceListReadingView()
}
