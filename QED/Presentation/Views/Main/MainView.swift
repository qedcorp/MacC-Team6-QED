//
//  MainView.swift
//  QED
//
//  Created by chaekie on 10/17/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()

    @State private var path: [PresentType] = [] {
        didSet {
            if path == [] {
                DispatchQueue.global().async {
                    viewModel.fetchMyRecentPerformances()
                }
                return
            }
        }
    }

    private let horizontalPadding: CGFloat = 24

    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 34) {
                    Spacer()
                    buildHeaderView()
                    buildContentView()
                }
                .padding(.bottom, 40)
                buildMyPageButton()
                    .padding([.top, .trailing], 24)
            }
            .background(
                buildBackgroundView()
            )
            .navigationBarBackButtonHidden()
            .navigationDestination(for: PresentType.self) {
                MainCoordinator(path: $path).buildView(presentType: $0)
                    .onDisappear {
                        viewModel.fetchMyRecentPerformances()
                    }
            }
        }
        .task {
            viewModel.fetchMyRecentPerformances()
        }
    }

    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            buildMainTitleView()
            buildMakeFormationButtonView()
        }
        .padding(.horizontal, horizontalPadding)
    }

    private func buildContentView() -> some View {
        VStack(spacing: 19) {
            buildPerformanceListHeaderView()
            ZStack {
                if viewModel.isFetchingPerformances {
                    FodiProgressView()
                } else if viewModel.myRecentPerformances.isEmpty {
                    buildPerformanceListEmptyView()
                } else {
                    buildPerformanceListScrollView()
                }
            }
            .frame(height: 198)
        }
    }

    private func buildMainTitleView() -> some View {
        let fontSize: CGFloat = 26
        return HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    Text("내 ")
                    Text("손")
                        .font(.fodiFont(.pretendardBlack, size: fontSize))
                    Text(" 안의")
                }
                Text("포메이션 디렉터")
                    .font(.fodiFont(.pretendardBlack, size: fontSize))
                HStack(spacing: 0) {
                    Text("FODI")
                        .foregroundStyle(Color.blueLight3)
                        .font(.fodiFont(.pretendardBlack, size: fontSize))
                    Text(" 와 함께")
                }
            }
            .foregroundStyle(Color.monoWhite3)
            .font(.fodiFont(.pretendardSemiBold, size: fontSize))
            .kerning(-0.38)
            Spacer()
        }
    }

    private func buildMakeFormationButtonView() -> some View {
        Button {
            let dependency = PerformanceSettingViewDependency()
            path.append(.performanceSetting(dependency))
        } label: {
            Image("performanceSetting")
        }
    }

    private func buildPerformanceListHeaderView() -> some View {
        HStack {
            Text("최근 프로젝트")
                .foregroundStyle(Color.monoWhite3)
                .font(.fodiFont(.pretendardBlack, size: 20))
                .kerning(0.38)
            Spacer()
            Button {
                let dependency = PerformanceListReadingViewDependency(performances: viewModel.myPerformances)
                path.append(.performanceListReading(dependency))
            } label: {
                Image("listReading")
            }
        }
        .padding(.horizontal, horizontalPadding)
        .frame(height: 42)
    }

    private func buildPerformanceListEmptyView() -> some View {
        Image("mainlistEmpty")
    }

    private func buildPerformanceListScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.myRecentPerformances) { performance in
                    Button {
                        let nextPath = PerformanceRouter(performance: performance).getItemPath()
                        path.append(nextPath)
                    } label: {
                        PerformanceListCardView(performance: performance)
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
        }
    }

    private func buildBackgroundView() -> some View {
        Image("mainBackground")
            .resizable()
            .ignoresSafeArea(.all)
    }

    private func buildMyPageButton() -> some View {
        Button {
            let dependency = MyPageViewDependency()
            path.append(.myPage(dependency))
        } label: {
            Image("profile")
        }
    }
}

#Preview {
    MainView()
}
