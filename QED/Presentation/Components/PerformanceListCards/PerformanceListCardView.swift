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

    init(performance: Performance) {
        self.performance = performance
        performanceTitle = performance.title ?? "_"
        musicTitle = performance.music.title
        creator = performance.music.artistName
        albumCoverURL = performance.music.albumCoverURL
        headcount = performance.headcount
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                AsyncImage(url: performance.music.albumCoverURL) { phase in
                    switch phase {
                    case.empty:
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
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
                .frame(height: geometry.size.height * 0.18)

                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(performanceTitle)")
                            .font(.footnote)
                            .bold()
                            .opacity(0.8)
                            .lineLimit(1)
                            .padding(.bottom, 1)

                        Text("\(creator) - \(musicTitle)")
                            .font(.caption2)
                            .opacity(0.6)
                            .lineLimit(1)
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
                .padding(.top, 15)
                .padding(.horizontal)

                Spacer()
                    .padding()

            }
            .frame(width: geometry.size.width * 0.418, height: geometry.size.height * 0.235)
            .background(Gradient.blueGradation2)
            .foregroundStyle(Color.monoWhite3)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    PerformanceListCardView(performance: mockPerformance1)
}
