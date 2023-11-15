//
//  PerformanceListCardView.swift
//  QED
//
//  Created by OLING on 10/28/23.
//

import SwiftUI

struct PerformanceListCardView: View {
    let performance: Performance
    var performanceTitle: String
    var musicTitle: String
    var creator: String
    var albumCoverURL: URL?
    var image: UIImage?
    var headcount: Int
    @State private var isLoading = true
    @State private var isMusic = true

    init(performance: Performance) {
        self.performance = performance
        performanceTitle = performance.title ?? "_"
        musicTitle = performance.music.title
        creator = performance.music.artistName
        albumCoverURL = performance.music.albumCoverURL
        headcount = performance.headcount
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                if isMusic {
                    AsyncImage(url: performance.music.albumCoverURL) { phase in
                        switch phase {
                        case.empty:
                            VStack {
                                HStack(alignment: .center) {
                                    Spacer()
                                    FodiProgressView()
                                    Spacer()
                                }
                            }
                            .padding(.top, 20)
                        case.success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case.failure:
                            Image(systemName: "exclamationmark.circle.fill")
                        @unknown default:
                            Image(systemName: "exclamationmark.circle.fill")
                        }
                    }
                    .frame(height: 170)
                } else {
                    EmptyView()
                        .frame(height: 170)
                }

                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(performanceTitle)")
                            .font(.footnote)
                            .bold()
                            .opacity(0.8)
                            .lineLimit(1)
                            .padding(.bottom, 1)
                            .truncationMode(.tail)

                        Text(isMusic
                             ?"\(musicTitle)"
                             :"선택한 노래없음"
                        )
                        .font(.caption2)
                        .opacity(0.6)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    }
                    Spacer()
                    Text("\(headcount)")
                        .foregroundStyle(Color.blueDark)
                        .font(.footnote)
                        .bold()
                        .background(
                            Circle()
                                .fill(Color.monoWhite3)
                                .frame(width: 27, height: 27)
                        )
                }
                .padding(.top, 5)
                .padding(.horizontal, 30)
//                .padding(.leading, 15)
//                .padding(.trailing, 15)

                Spacer()
                    .padding()

            }

            VStack {
                Spacer()
                    Button {
                        // TODO: 수정버튼
                    } label: {
                        Image("ellipsis")
                    }
                Spacer()
            }
            .padding(.leading, 125)
            .padding(.bottom, 150)
        }
        .frame(width: 163, height: 198)
        .background(Gradient.blueGradation2)
        .foregroundStyle(Color.monoWhite3)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    PerformanceListCardView(performance: mockPerformance1)
}
