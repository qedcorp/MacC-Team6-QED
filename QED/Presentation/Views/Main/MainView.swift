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
            VStack(spacing: 30) {
                buildMainTopView()
                buildMakeFormationButtonView()
                buildPerformanceListHeaderView()
                if viewModel.myRecentPerformances.isEmpty {
                    buildEmptyView()
                } else {
                    buildPerformanceListScrollView()
                }
                Spacer()
            }
            .ignoresSafeArea()
            .toolbar {
                leftItem()
                rightItem()
            }
        }
        .onAppear {
            viewModel.fetchUser()
        }
        .navigationBarBackButtonHidden()
    }

    private func buildMainTopView() -> some View {
        Image("MockMain")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }

    private func buildMakeFormationButtonView() -> some View {
        HStack {
            Text("동선 만들기")
                .font(.title)
                .bold()
                .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
            Spacer()
            NavigationLink {
                TitleSetupView(performanceUseCase: viewModel.performanceUseCase)
            } label: {
                Text("Go")
                    .font(.title2)
                    .bold()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                    .background(Color(red: 0, green: 0.97, blue: 0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .onAppear {
                viewModel.fetchMyRecentPerformances()
            }
        }
        .padding(.horizontal, 20)
    }

    private func buildPerformanceListHeaderView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("최근 제작한 동선")
                    .font(.title3)
                    .bold()
                Text("동선 만들기를 완료한 후 디렉팅하세요")
                    .font(.caption)
            }
            Spacer()
            NavigationLink {
                PerformanceListReadingView()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
            }
        }
        .bold()
        .padding(.horizontal, 20)
    }

    private func buildEmptyView() -> some View {
        VStack {
            Image("MainListEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            Text("만들어진 동선이 없어요")
                .font(.headline)
                .bold()
                .foregroundStyle(Color(red: 0.45, green: 0.87, blue: 0.98))
        }
        .padding(.top, 30)
        .opacity(0.5)
    }

    private func buildPerformanceListScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.myRecentPerformances) { performance in
                    NavigationLink {
                        PerformanceWatchingDetailView(
                            viewModel: PerformanceWatichingDetailViewModel(performance: performance)
                        )
                    } label: {
                        PerformanceListCardView(performance: performance)
                    }
                }
            }
        }
        .padding(.leading, 20)
    }

    private func leftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("Fodi")
                .fontWeight(.bold)
                .kerning(0.4)
        }
    }

    private func rightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                MyPageView()
            } label: {
                Image(systemName: "person.circle")
                    .foregroundColor(Color.green)
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

extension Performance: Identifiable { }
