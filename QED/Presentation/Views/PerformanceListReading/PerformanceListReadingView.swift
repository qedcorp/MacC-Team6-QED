//
//  PerformanceListReadingView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct PerformanceListReadingView: View {
    let performances: [Performance]
    @ObservedObject var viewModel: PerformanceListReadingViewModel
    @Environment(\.dismiss) private var dismiss

    init(performances: [Performance]) {
        self.performances = performances
        self.viewModel = PerformanceListReadingViewModel(performances: performances)
    }

    let columns: [GridItem] = [
        GridItem(spacing: 0, alignment: nil),
        GridItem(spacing: 0, alignment: nil)]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                buildPerformanceCountView()
                buildPerformaceListView()
            }
            .padding(.horizontal, 24)
        }
        .background(
            Image("background")
                .resizable()
                .ignoresSafeArea(.all)
        )
        .foregroundStyle(Color.monoWhite3)
        .navigationBarBackButtonHidden()
        .toolbar {
            buildLeftItem()
            buildCenterItem()
        }
    }

    private func buildPerformaceListView() -> some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 25) {
            ForEach(viewModel.performances) { performance in
                PerformanceListCardView(performance: performance.entity)
            }
        }
    }

    private func buildPerformanceCountView() -> some View {
        HStack {
            Text("전체(\(viewModel.performances.count))")
                .font(.headline)
                .bold()
                .foregroundStyle(Color.monoWhite3)
            Spacer()
        }
        .padding(.top, 20)
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.blueLight3)
            }
        }
    }

    private func buildCenterItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Text("제작한 프로젝트")
                .bold()
                .foregroundStyle(Color.monoWhite3)
        }
    }
}

 #Preview {
    PerformanceListReadingView(performances: [mockPerformance1])
 }
