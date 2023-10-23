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
        NavigationStack {
            VStack {
                VStack {
                    Image("MockMain")
                        .ignoresSafeArea()
                        .scaleEffect(1.01)
                        .frame(height: 310)
                    makeFormation
                    myRecentFormationHeader
                }
                .padding(.horizontal, 20)
                MyRecentFormationScrollView(viewModel: viewModel)
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
    }

    private var makeFormation: some View {
        HStack {
            Text("동선 만들기")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))

            Spacer()

            Button {
                    // TitleSettingView
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

    private var myRecentFormationHeader: some View {
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
            NavigationLink(destination: MyRecentFormationView()) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .font(.title)
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
            NavigationLink(destination: MyPageView()) {
                Image(systemName: "person.circle")
                    .foregroundColor(Color.green)
            }
        }
    }
}

struct MyRecentFormationScrollView: View {
    @StateObject var viewModel: MainViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.myRecentPerformances, id: \.self) { performance in
                    NavigationLink(value: performance) {
                        RecentFormationCardView(performance: performance)
                    }
                    .navigationDestination(for: Performance.self) { performance in
                        WatchingFormationView(performance: performance)
                    }
                }
            }
        }
        .padding(.leading, 20)
    }
}

struct RecentFormationCardView: View {
    let performance: Performance
    var title: String
    var creator: String
    var thumbnailURL: URL?
    var image: UIImage?

    init(performance: Performance) {
        self.performance = performance
        title = performance.title ?? ""
        creator = performance.playable.creator
        thumbnailURL = performance.playable.thumbnailURL
    }

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: performance.playable.thumbnailURL) { image in
                image
                    .image?.resizable()
                    .scaledToFill()
            }
            VStack(alignment: .leading) {
                Text("\(title)")
                    .font(.system(size: 13))
                    .bold()
                    .foregroundColor(Color.black)
                    .opacity(0.8)

                Text("\(creator)")
                    .font(.system(size: 11))
                    .foregroundColor(Color.black)
                    .opacity(0.6)
            }
            .padding(.horizontal)

            Spacer()
        }
        .frame(width: 152, height: 198)
        .background(Color(.systemGray6))
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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

#Preview {
    MainView()
}
