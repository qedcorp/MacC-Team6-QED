//
//  MainView.swift
//  QED
//
//  Created by chaekie on 10/17/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            VStack(spacing: 25) {
                BannerView()
                myRecentFormationHeader
            }
            .padding(.horizontal, 20)
            MyRecentFormationScrollView()
        }
    }

    private var myRecentFormationHeader: some View {
        HStack {
            Text("최근 나의 자리표")
            Spacer()
            Button {
                // TODO: 최근 나의 자리표 리스트 페이지로 이동
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .font(.title)
        .bold()
    }
}

struct BannerView: View {
    var nickname = "어찌구 저찌구"

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            bannerBackground
            bannerInfo
        }
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
        Button {
            // TODO: 자리표따기로 이동
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
                ForEach(0..<10) {_ in
                    RecentFormationCardView()
                }
            }
        }
        .padding(.leading, 20)
    }
}

struct RecentFormationCardView: View {
    var title = "pink venom"
    var artistName = "black pink"

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("\(title)-\n\(artistName)")
                    .bold()
                Spacer()
            }
        }
        .padding()
        .frame(width: 160, height: 120)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    MainView()
}
