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
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 25) {
//                ForEach(viewModel.myRecentPerformances) { performance in
//                    NavigationLink {
//                        PerformanceWatchingListView(performance: performance.entity,
//                                                    performanceUseCase: viewModel.performanceUseCase)
//                    } label: {
//                        PerformanceListCardView(performance: performance)
//                    }
//                }
            }
        }
        .onAppear {
            viewModel.fetchMyRecentPerformances()
        }
        .navigationTitle("제작 동선 리스트")
        .navigationBarBackButtonHidden()
        .toolbar {
            leftItem
        }
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
            }
        }
    }
}

#Preview {
    PerformanceListReadingView()
}
