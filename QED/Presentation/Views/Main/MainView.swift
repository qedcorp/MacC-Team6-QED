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
            VStack(alignment: .leading) {
                HStack {
                    leftItem()
                    Spacer()
                    rightItem()
                }
                .padding(.horizontal, 24)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        mainTitle()
                        buildMakeFormationButtonView()
                        buildPerformanceListHeaderView()
                        if viewModel.myRecentPerformances.isEmpty {
                            buildEmptyView()
                        } else {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 25, pinnedViews: .sectionHeaders) {
                                Section {
                                    buildPerformanceListScrollView()
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top, 130)
                }
            }
            .background(
                ZStack {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea(.all)
                    VStack {
                        buildMainTopView()
                        Spacer()
                    }
                }.ignoresSafeArea()
            )
            .onAppear {
                viewModel.fetchUser()
            }
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
                    FormationSettingView(performance: performance,
                                         performanceUseCase: viewModel.performanceUseCase,
                                         path: $path
                    )
                case let .performanceListReading(performances):
                    PerformanceListReadingView(performances: performances)
                case let .performanceWatching(performance, isAllFormationVisible):
                    if performance.isCompleted {
                        PerformanceWatchingDetailView(performance: performance, isAllFormationVisible: isAllFormationVisible)
                    } else {
                        FormationSettingView(performance: performance,
                                             performanceUseCase: viewModel.performanceUseCase,
                                             path: $path
                        )
                    }
                }
            }
            .navigationBarBackButtonHidden()
        }
    }

    private func buildMainTopView() -> some View {
        Image("lese")
            .resizable()
            .scaledToFit()
            .mask(
                LinearGradient(gradient:
                                Gradient(colors: [Color.black, Color.black, Color.black, Color.black.opacity(0)]),
                               startPoint: .top,
                               endPoint: .bottom)
            )
    }

    private func mainTitle() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("내 손안에")
                    .font(.fodiFont(Font.FodiFont.pretendardBold, size: 26))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.monoWhite3)
                Text("포메이션 디렉터")
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
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
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
        .padding(.horizontal, 20)
        .padding(.top, 20)
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
        .padding(.horizontal, 24)
    }

    private func leftItem() -> some View {
        Image("FodiIcon")
            .resizable()
            .frame(width: 50, height: 28)

    }

    private func rightItem() -> some View {
        Image("profile")
            .resizable()
            .frame(width: 24, height: 24)
            .onTapGesture {
                path.append(.myPage)
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

extension Performance: Identifiable { }
