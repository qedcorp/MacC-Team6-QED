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
    @State var voidPath: [PresentType] = []

    var body: some View {
        NavigationStack(path: $voidPath) {
            VStack {
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
                        if viewModel.myRecentPerformances.isEmpty {
                            buildEmptyView()
                        } else {
                            LazyVGrid(columns: columns, alignment: .center, spacing: 25, pinnedViews: .sectionHeaders) {
                                Section {
                                    buildPerformanceListScrollView()
                                } header: {
                                    buildPerformanceListHeaderView()
                                }
                            }
                            .padding(.horizontal, 7)
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
                    PerformanceSettingView(performanceUseCase: viewModel.performanceUseCase)
                case let .formationSetting(performance):
                    FormationSettingView(performance: performance,
                                         performanceUseCase: viewModel.performanceUseCase)
                case let .performanceListReading(performances):
                    PerformanceListReadingView()
                case let .performanceWatching(performance):
                    PerformanceWatchingDetailView(
                        viewModel: <#T##PerformanceWatchingDetailViewModel#>,
                        index: <#T##Int#>)
                    
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
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
            .opacity(0.5)
    }

    let columns: [GridItem] = [
        GridItem(spacing: 0, alignment: nil),
        GridItem(spacing: 0, alignment: nil)]

    private func buildPerformanceListScrollView() -> some View {
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

    private func leftItem() -> some View {
        Image("FodiIcon")
            .resizable()
            .frame(width: 50, height: 28)

    }

    private func rightItem() -> some View {
        NavigationLink {
            MyPageView()
        } label: {
            Image("profile")
                .resizable()
                .frame(width: 24, height: 24)
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
