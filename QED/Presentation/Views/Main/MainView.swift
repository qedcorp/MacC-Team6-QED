//
//  MainView.swift
//  QED
//
//  Created by chaekie on 10/17/23.
//

import SwiftUI
import Mixpanel
import AirBridge

struct MainView: View {
    
    @StateObject private var viewModel = MainViewModel()
    @State private var isSendFeedbackOn = false
    @Environment(\.openURL) private var openURL
    private let feedbackURL = "https://forms.gle/1LTQh5baqV2irxq99"

    @State private var path: [PresentType] = [] {
        didSet {
            if path == [] {
                DispatchQueue.main.async {
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
            .onOpenURL { url in
                let isLoggedIn = try? KeyChainManager.shared.read(account: .id)
                print(url.getQueryParameters())
                let performanceId = url.getQueryParameters()["pId"]
                if let pId = performanceId,
                   isLoggedIn != nil {
                    path = []
                    Task {
                        do {
                            let performance = try await viewModel.performanceUseCase.searchPerformance(pId)

                            if performance.id == "" { return }
                            if !viewModel.myPerformances.contains(where: { $0.id == pId }) {
                                _ = try await viewModel.performanceUseCase.createPerformance(performance: performance)
                            }
                            let nextPath = PerformanceRouter(performance: performance).getBranchedPath()
                            DispatchQueue.main.async {
                                path.append(nextPath)
                            }

                        } catch {
                            print("@Search error")
                        }
                    }
                }
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
            .onAppear {
                viewModel.fetchMyRecentPerformances()
                Task {
                    let me = try? await viewModel.userUseCase.getMe()
                    let launchingCount = me?.launchingCount ?? 1
                    if (launchingCount == 2 || launchingCount % 3 == 0) && launchingCount > 0 {
                        isSendFeedbackOn = true
                    }
                }
            }
        }
        .alert("개선의견 남기러가기", isPresented: $isSendFeedbackOn, actions: {
            Button("취소", role: .cancel) { isSendFeedbackOn = false }
            Button("확인", role: .destructive) {
                isSendFeedbackOn = false
                viewModel.userUseCase.resetLaunchingCount()
                openURL(feedbackURL)
            }
        }) {
            Text("누구나 FODI를 바꾸어 나갈 수 있어요! \n\n FODI를 개선하는 기회에 참여하고\n 더 쉽고 편하게 동선표를 제작해보세요:)")
        }
    }

    private func openURL(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        openURL(url)
    }

    private func buildHeaderView() -> some View {
        VStack(alignment: .leading, spacing: 24) {
            buildMainTitleView()
            buildMakeFormationButtonView()
        }
        .padding(.horizontal, horizontalPadding)
    }

    private func buildMainTitleView() -> some View {
        let fontSize: CGFloat = 26
        return HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    Text("내 ")
                    Text("손")
                        .font(.fodiFont(.pretendardBlack, size: fontSize))
                    Text("안의")
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
            MixpanelManager.shared.track(.tabGenerateProjectBtn)
            let dependency = PerformanceSettingViewDependency()
            path.append(.performanceSetting(dependency))
        } label: {
            Image("performanceSetting")
        }
    }

    private func buildContentView() -> some View {
       VStack(spacing: 19) {
           buildPerformanceListHeaderView()
           ZStack {
               if viewModel.isFetchingPerformances {
                   ProgressView()
                       .tint(Color.blueLight3)
               } else if viewModel.myRecentPerformances.isEmpty {
                   buildPerformanceListEmptyView()
               } else {
                   buildPerformanceListScrollView()
               }
           }
           .frame(height: 198)
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
                        MixpanelManager.shared.track(.tabSomePerformance)
                        let nextPath = PerformanceRouter(performance: performance).getBranchedPath()
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
            MixpanelManager.shared.track(.tabProfileBtn)
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
