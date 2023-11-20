// Created by byo.

import SwiftUI

struct MainCoordinator {
    let path: Binding<[PresentType]>

    @MainActor
    @ViewBuilder
    func buildView(presentType: PresentType) -> some View {
        switch presentType {
        case let .performanceSetting(dependency):
            let viewModel = PerformanceSettingViewModel(performanceUseCase: dependency.performanceUseCase)
            PerformanceSettingView(viewModel: viewModel, path: path)

        case let .performanceLoading(dependency):
            PerformanceLoadingView(dependency: dependency, path: path)

        case let .formationSetting(dependency):
            FormationSettingView(dependency: dependency, path: path)

        case let .memberSetting(dependency):
            MemberSettingView(dependency: dependency, path: path)

        case let .performanceWatching(dependency):
            PerformanceWatchingDetailView(dependency: dependency, path: path)

        case let .myPage(dependency):
            MyPageView(toastContainerViewModel: dependency.toastContainerViewModel, path: path)

        case let .accountInfo(dependency):
            AccountInfoView(viewModel: dependency.myPageViewModel)

        case let .performanceListReading(dependency):
            let viewModel = PerformanceListReadingViewModel(
                performances: dependency.performances,
                toastContainerViewModel: dependency.toastContainerViewModel
            )
            PerformanceListReadingView(viewModel: viewModel, path: path)
        }
    }
}
