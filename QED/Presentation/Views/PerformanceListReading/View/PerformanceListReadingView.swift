//
//  PerformanceListReadingView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceListReadingView: View {

    @StateObject private var viewModel = MainViewModel(
        performancesUseCase: DefaultPerformanceUseCase(
            performanceRepository: MockPerformanceRepository(),
            userStore: DefaultUserStore.shared))

    let columns: [GridItem] = [
        GridItem( spacing: 0, alignment: nil),
        GridItem( spacing: 0, alignment: nil)]

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 25) {
                ForEach(viewModel.myRecentPerformances, id: \.self) { performance in
                    NavigationLink(destination: PerformanceWatchingListView(viewModel: PerformanceWatchingListViewModel(performance: performance))) {
                        RecentFormationCardView(performance: performance)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchMyRecentPerformances()
        }
        .navigationTitle("최근 제작 동선")
        .navigationBarBackButtonHidden()
        .toolbar {
            leftItem
            rightItem
        }
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            NavigationLink(destination: MainView()) {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
                    .bold()
            }
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                // 선택은 나중에 할래...
            } label: {
                Text("선택")
                    .bold()
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
            }
        }
    }
}

#Preview {
    PerformanceListReadingView()
}
