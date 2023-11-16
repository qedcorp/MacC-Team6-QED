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

    @State var path: [PresentType] = [] {
        didSet {
            if path.isEmpty {
                DispatchQueue.global().async {
                    viewModel.fetchMyRecentPerformances()
                }
            }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        mainTitle()
                        buildMakeFormationButtonView()
                        buildPerformanceListHeaderView()
                        if viewModel.myRecentPerformances.isEmpty {
                            buildEmptyView()
                        } else {
                            LazyVGrid(columns: columns,
                                      alignment: .center,
                                      spacing: 25,
                                      pinnedViews: .sectionHeaders) {
                                buildPerformanceListScrollView()
                            }
                        }
                    }
                    .padding(.top, 130)
                }
            }
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    Image("background")
                        .resizable()
                    VStack {
                        buildMainTopView()
                        Spacer()
                    }
                }.ignoresSafeArea(.all)
            )
            .onAppear {
                viewModel.fetchUser()
            }
            .toolbar {
                buildLeftItem()
                buildRightItem()
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(for: PresentType.self) { persentType in
                switch persentType {
                case .myPage:
                    MyPageView()
                case .performanceSetting:
                    PerformanceSettingView(
                        performanceUseCase: viewModel.performanceUseCase,
                        path: $path
                    )
                case let .formationSetting(performance):
                    FormationSettingView(
                        performance: performance,
                        performanceUseCase: viewModel.performanceUseCase,
                        path: $path
                    )
                case let .performanceListReading(performances):
                    PerformanceListReadingView(performances: performances)
                case let .performanceWatching(performance, isAllFormationVisible):
                    if performance.isCompleted {
                        PerformanceWatchingDetailView(
                            performance: performance,
                            isAllFormationVisible: isAllFormationVisible)
                    } else {
                        FormationSettingView(
                            performance: performance,
                            performanceUseCase: viewModel.performanceUseCase,
                            path: $path
                        )
                    }
                }
            }
        }
    }

    private func buildMainTopView() -> some View {
        Image("lese")
            .resizable()
            .scaledToFit()
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    private func mainTitle() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("내 손안에")
                Text("포메이션 디렉터")
                HStack(spacing: 0) {
                    Text("FODI")
                        .foregroundStyle(Color.blueLight3)
                    Text(" 와 함께,")
                    Spacer()
                }
            }
            .font(.fodiFont(Font.FodiFont.pretendardBold, size: 26))
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.monoWhite3)
            Spacer()
        }
        .padding(.bottom, 34)
    }

    private func buildMakeFormationButtonView() -> some View {
        HStack {
            Image("performanceSetting")
                .onTapGesture {
                    path.append(.performanceSetting)
                }
                .onAppear {
                    DispatchQueue.global().async {
                        viewModel.fetchMyRecentPerformances()
                    }
                }
            Spacer()
        }
        .padding(.bottom, 46)
    }

    private func buildPerformanceListHeaderView() -> some View {
        HStack(alignment: .center) {
            Text("최근 프로젝트")
                .font(.fodiFont(Font.FodiFont.pretendardBlack, size: 20))
                .kerning(0.38)
                .foregroundStyle(Color.monoWhite3)

            Spacer()

            Image("listReading")
                .onTapGesture {
                    path.append(.performanceListReading(viewModel.myRecentPerformances))
                }
        }
        .padding(.bottom, 18)
    }

    private func buildEmptyView() -> some View {
        Image("mainlistEmpty")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
            .opacity(0.5)
    }

    let columns: [GridItem] = [
        GridItem(spacing: 10, alignment: nil),
        GridItem(spacing: 10, alignment: nil)]

    private func buildPerformanceListScrollView() -> some View {
        let myRecentPerformances = viewModel.myRecentPerformances
            .sorted { lhs, rhs in
                lhs.createdAt < rhs.createdAt
            }
        return ForEach(myRecentPerformances) { performance in
            PerformanceListCardView(performance: performance)
                .onTapGesture {
                    path.append(.performanceWatching(performance, false))
                }
        }
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Image("FodiIcon")
                .padding(.leading, 8)
        }
    }

    private func buildRightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Image("profile")
                .padding(.trailing, 8)
                .onTapGesture {
                    path.append(.myPage)
                }
        }
    }
}

extension Performance: Identifiable, Hashable {
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
