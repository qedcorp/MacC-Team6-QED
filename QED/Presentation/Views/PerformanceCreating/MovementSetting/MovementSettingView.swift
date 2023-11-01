// Created by byo.

import SwiftUI

struct MovementSettingView: View {
    @ObservedObject private var viewModel: MovementSettingViewModel

    init(performance: Performance, performanceUseCase: PerformanceUseCase) {
        let performanceSettingManager = PerformanceSettingManager(
            performance: performance,
            performanceUseCase: performanceUseCase
        )
        self.viewModel = MovementSettingViewModel(performanceSettingManager: performanceSettingManager)
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                if !viewModel.isZoomed {
                    buildMovementView(
                        controller: viewModel.movementController,
                        width: geometry.size.width,
                        color: .gray.opacity(0.1)
                    )
                    buildHistoryControlsView()
                        .padding(.vertical)
                }
                HStack {
                    Button("이전") {
                        viewModel.gotoBefore()
                    }
                    Button("다음") {
                        viewModel.gotoAfter()
                    }
                }
                Spacer()
            }
        }
        .overlay(
            viewModel.isZoomed ?
            buildZoomableView()
            : nil
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PerformanceSettingTitleView(step: 3, title: "세부동선 테스트")
            }
        }
    }

    private func buildMovementView(
        controller: ObjectMovementAssigningViewController,
        width: CGFloat,
        color: Color
    ) -> some View {
        let height = width * CGFloat(22 / Float(35))
        return ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
            if let beforeFormation = viewModel.beforeFormation?.entity,
               let afterFormation = viewModel.afterFormation?.entity {
                ObjectMovementAssigningView(
                    controller: controller,
                    beforeFormation: beforeFormation,
                    afterFormation: afterFormation,
                    onChange: {
                        viewModel.updateMembers(movementMap: $0)
                    }
                )
            }
        }
        .frame(width: width, height: height)
        .clipped()
    }

    private func buildZoomableView() -> some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                ZoomableView {
                    buildMovementView(
                        controller: viewModel.zoomableMovementController,
                        width: geometry.size.width,
                        color: .white
                    )
                }
            }
            buildHistoryControlsView()
                .padding()
                .background(.white)
        }
    }

    private func buildHistoryControlsView() -> some View {
        HStack {
            HistoryControlsView(
                historyControllable: viewModel.objectHistoryArchiver,
                tag: viewModel.currentFormationTag
            )
            Spacer()
            Button("Zoom") {
                viewModel.isZoomed.toggle()
            }
        }
    }
}
