//
//  MainView.swift
//  QED
//
//  Created by chaekie on 10/17/23.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel(
        performancesUseCase: DefaultPerformanceUseCase(
            performanceRepository: MockPerformanceRepository(),
            userStore: DefaultUserStore.shared))

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    mainTop
                    makeFormation
                    performanceListReadingHeader
                }
                .padding(.horizontal, 20)
                if viewModel.myRecentPerformances.isEmpty {
                    mainListEmptyView
                } else {
                    PerformanceListReadingScrollView(viewModel: viewModel)
                }
            }
            .toolbar {
                leftItem
                rightItem
            }
        }
        .onAppear {
            viewModel.fetchUser()
            viewModel.fetchMyRecentPerformances()
        }
        .navigationBarBackButtonHidden()
    }

    private var mainTop: some View {
        Image("MockMain")
            .ignoresSafeArea()
            .scaleEffect(1.01)
            .frame(height: 310)
    }

    private var makeFormation: some View {
        HStack {
            Text("동선 만들기")
                .font(.title)
                .bold()
                .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))

            Spacer()

            NavigationLink {
                TitleSetupView(performancesettingVM: PerformanceSettingViewModel())
            } label: {
                Text("Go")
                    .frame(width: 86, height: 56)
                    .font(.title)
                    .bold()
                    .kerning(0.38)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(red: 0, green: 0.97, blue: 0.04))
                    )
            }
        }
    }

    private var performanceListReadingHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("최근 제작한 동선")
                    .font(
                        Font.custom("Apple SD Gothic Neo", size: 20)
                            .weight(.bold)
                    )
                    .kerning(0.38)

                Text("동선 만들기를 완료한 후 디렉팅하세요")
                    .font(Font.custom("Apple SD Gothic Neo", size: 11))
                    .kerning(0.07)
            }
            Spacer()
            NavigationLink {
                PerformanceListReadingView()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .bold()
        .padding(.vertical)
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("Formy")
                .fontWeight(.heavy)
                .kerning(0.4)
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                MyPageView()
            } label: {
                Image(systemName: "person.circle")
                    .foregroundColor(Color.green)
            }
        }
    }

    private var mainListEmptyView: some View {
        VStack {
            Spacer()
            Image("MainListEmpty")
                .resizable()
                .scaledToFit()
                .frame(width: 106, height: 106)

            Text("만들어진 동선이 없어요")
                .font(.title3)
                .bold()
                .foregroundStyle(Color(red: 0.45, green: 0.87, blue: 0.98))
            Spacer()
        }
        .opacity(0.5)
    }
}

struct PerformanceListReadingScrollView: View {
    @StateObject var viewModel: MainViewModel
    @State var selctePerformance: Performance?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.myRecentPerformances, id: \.self) { performance in
                    NavigationLink {
                        PerformanceWatchingView(performance: performance)
                    } label: {
                        PerformanceListCardView(performance: performance)
                    }
                }
            }
        }
        .padding(.leading, 20)
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
