//
//  MainView.swift
//  QED
//
//  Created by chaekie on 10/17/23.
//

import SwiftUI

struct MainView: View {
    var nickname = "어쩌구 저쩌구"

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 25) {
                    BannerView(nickname: nickname)
                    myRecentFormationHeader
                }
                .padding(.horizontal, 20)
                MyRecentFormationScrollView()
            }
            .toolbar {
                leftItem
                rightItem
            }
        }
    }

    private var myRecentFormationHeader: some View {
        HStack {
            Text("최근 나의 자리표")
            Spacer()
            NavigationLink(destination: MyRecentFormationView()) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .font(.title)
        .bold()
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

struct BannerView: View {
    let nickname: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            bannerBackground
            bannerInfo
        }
        .padding(.top, 10)
    }

    private var bannerBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .shadow(radius: 5)
    }

    private var bannerInfo: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("안녕하세요\n\(nickname) 님")
            makeFormationButton
        }
        .font(.title)
        .bold()
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }

    private var makeFormationButton: some View {
        NavigationLink {
            FormationSetupView(
                performanceUseCase: DefaultPerformanceUseCase(
                    performanceRepository: MockPerformanceRepository(),
                    userStore: DefaultUserStore.shared
                ),
                performance: Performance(
                    author: .sample,
                    playable: Music.newJeans,
                    headcount: 5
                )
            )
        } label: {
            HStack {
                Text("자리표 만들기")
                Image(systemName: "chevron.right")
                    .font(.footnote)
            }
            .font(.subheadline)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .foregroundStyle(.green)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct MyRecentFormationScrollView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(0..<10) { performance in
                    NavigationLink(value: performance) {
                        RecentFormationCardView(performance: performance)
                    }
                    .navigationDestination(for: Int.self) { _ in
                        WatchingFormationView()
                    }
                }

            }
        }
        .padding(.leading, 20)
    }
}

private struct RecentFormationCardView: View {
    var performance: Int
    var title = "pink venom"
    var creator = "black pink"

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("\(performance)\n\(title)-\n\(creator)")
                    .bold()
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                Spacer()
            }
        }
        .padding()
        .frame(width: 160, height: 120)
        .background(Color(.systemGray6))
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    MainView()
}
