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

    @State var isFetchingPerformances = true
    @State var path: [PresentType] = [] {
        didSet {
            if path.isEmpty {
                DispatchQueue.global().async {
                    isFetchingPerformances = true
                    viewModel.fetchMyRecentPerformances(isFetchingDone)
                }
            }
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        buildMainTitle()
                        buildMakeFormationButtonView()
                        buildPerformanceListHeaderView()
                        if viewModel.myRecentPerformances.isEmpty && !isFetchingPerformances {
                            buildEmptyView()
                        } else if isFetchingPerformances {
                            FodiProgressView()
                                .padding(.top, 100)
                        } else {
                            buildPerformanceListScrollView()
                        }
                    }
                    .padding(.top, 130)
                }
            }
            .padding(.horizontal, 24)
            .background(
                buildBackgroundView()
            )
            .onAppear {
                viewModel.fetchUser()
            }
            .toolbar {
                buildLeftItem()
                buildRightItem()
            }
            .navigationBarBackButtonHidden()
            .toolbarBackground(Material.ultraThin, for: .navigationBar)
            .navigationDestination(for: PresentType.self) { persentType in
                switch persentType {
                case .myPage:
                    MyPageView()
                case .performanceSetting:
                    PerformanceSettingView(
                        performanceUseCase: viewModel.performanceUseCase,
                        path: $path
                    )
                case let .performanceLoading(transfer):
                    PerformanceLoadingView(transfer: transfer, path: $path)
                case let .performanceListReading(performances):
                    PerformanceListReadingView(performances: performances)
                case let .performanceWatching(transfer):
                    let viewModel = PerformanceWatchingDetailViewModel(
                        performanceSettingManager: transfer.performanceSettingManager
                    )
                    PerformanceWatchingDetailView(
                        viewModel: viewModel,
                        isAllFormationVisible: transfer.isAllFormationVisible,
                        path: $path
                    )
                case let .formationSetting(dependency):
                    FormationSettingView(dependency: dependency, path: $path)
                case let .memberSetting(dependency):
                    MemberSettingView(dependency: dependency, path: $path)                }
            }
        }
    }

    private let columns: [GridItem] = [
        GridItem(spacing: 16, alignment: nil),
        GridItem(spacing: 16, alignment: nil)]

    private func isFetchingDone() {
        isFetchingPerformances = false
    }

    private func buildMainTitle() -> some View {
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
                        viewModel.fetchMyRecentPerformances(isFetchingDone)
                    }
                }
            Spacer()
        }
        .padding(.bottom, 46)
    }

    private func buildPerformanceListHeaderView() -> some View {
        HStack(alignment: .top) {
            Text("최근 프로젝트")
                .font(.fodiFont(Font.FodiFont.pretendardBlack, size: 20))
                .kerning(0.38)
                .foregroundStyle(Color.monoWhite3)

            Spacer()

            Image("listReading")
                .padding(.bottom, 18)
                .onTapGesture {
                    path.append(.performanceListReading(viewModel.myRecentPerformances))
                }
        }

    }

    private func buildEmptyView() -> some View {
        Image("mainlistEmpty")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
            .opacity(0.5)
    }

    private func buildPerformanceListScrollView() -> some View {
        let myRecentPerformances = viewModel.myRecentPerformances
            .sorted { lhs, rhs in
                lhs.createdAt < rhs.createdAt
            }

        return LazyVGrid(columns: columns,
                         alignment: .center,
                         spacing: 24,
                         pinnedViews: .sectionHeaders) {
            ForEach(myRecentPerformances) { performance in
                PerformanceListCardView(performance: performance)
                    .onTapGesture {
                        if performance.isCompleted {
                            let manager = PerformanceSettingManager(performance: performance)
                            let transfer = PerformanceWatchingTransferModel(
                                performanceSettingManager: manager,
                                isAllFormationVisible: false
                            )
                            path.append(.performanceWatching(transfer))
                        } else {
                            let dependency = FormationSettingViewDependency(performance: performance)
                            path.append(.formationSetting(dependency))
                        }
                    }
            }
        }
                         .padding(.bottom, 40)
    }

    private func buildBackgroundView() -> some View {
        ZStack {
            Image("background")
                .resizable()
            VStack {
                buildMainTopView()
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
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
