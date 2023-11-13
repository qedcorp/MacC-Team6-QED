//
//  MainView.swift
//  QED
//
//  Created by chaekie on 10/17/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel(
        performanceUseCase: DIContainer.shared.resolver.resolve(PerformanceUseCase.self)
    )

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    VStack {
                        buildMainTopView()
                        Spacer()
                    }
                    VStack {
                        Spacer()
                            .frame(height: geometry.size.height * 0.27)
                        mainTitle()
                        buildMakeFormationButtonView()
                        buildPerformanceListHeaderView()
                        if viewModel.myRecentPerformances.isEmpty {
                            buildEmptyView()
                        } else {
                            buildPerformanceListScrollView()
                        }
                    }
                }
                .background(
                    Image("background")
                        .resizable()
                        .ignoresSafeArea(.all)
                )
                .ignoresSafeArea(.all)
                .toolbar {
                    leftItem()
                    rightItem()
                }
                .onAppear {
                    viewModel.fetchUser()
                }
                .navigationBarBackButtonHidden()
            }
        }
    }

    private func buildMainTopView() -> some View {
        Image("Main")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private func mainTitle() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("당신의")
                    .font(.fodiFont(Font.FodiFont.pretendardBold, size: 26))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.monoWhite3)
                Text("든든한 서포터")
                    .font(.fodiFont(Font.FodiFont.pretendardBold, size: 26))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.monoWhite3)
                HStack(alignment: .center, spacing: 0) {
                    Text("FODI")
                        .font(.fodiFont(Font.FodiFont.pretendardBold, size: 26))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.blueLight3)
                    Text(" 와 함께,")
                        .font(.fodiFont(Font.FodiFont.pretendardBold, size: 26))
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.monoWhite3)
                }
            }
            Spacer()
        }
        .padding(.vertical)
        .padding(.horizontal, 20)

    }
    private func buildMakeFormationButtonView() -> some View {
        HStack {
            NavigationLink {
                PerformanceSettingView(performanceUseCase: viewModel.performanceUseCase)
            } label: {
                Image("performanceSetting")
            }
            .onAppear {
                viewModel.fetchMyRecentPerformances()
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }

    private func buildPerformanceListHeaderView() -> some View {
        HStack {
            Text("최근 프로젝트")
                .font(.fodiFont(Font.FodiFont.pretendardBlack, size: 20))
                .kerning(0.38)
                .foregroundStyle(Color.monoWhite3)

            Spacer()
            NavigationLink {
                PerformanceListReadingView()
            } label: {
                Image("listReading")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func buildEmptyView() -> some View {
        Image("mainlistEmpty")
    }

    let columns: [GridItem] = [
        GridItem(spacing: 0, alignment: nil),
        GridItem(spacing: 0, alignment: nil)]

    private func buildPerformanceListScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 25) {
                ForEach(viewModel.myRecentPerformances) { performance in
                    NavigationLink {
                        PerformanceWatchingListView(
                            performance: performance.entity,
                            performanceUseCase: viewModel.performanceUseCase)
                    } label: {
                        PerformanceListCardView(performance: performance)
                    }
                }
            }
            .padding(.horizontal, 7)
        }
    }

    private func leftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Image("FodiIcon")
                .resizable()
        }
    }

    private func rightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                MyPageView()
            } label: {
                Image("profile")
                    .resizable()
            }
        }
    }
}

extension Performance: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Performance, rhs: Performance) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

#Preview {
    MainView()
}
