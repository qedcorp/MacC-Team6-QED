//
//  PerformanceListCardView.swift
//  QED
//
//  Created by OLING on 10/28/23.
//

import SwiftUI

struct PerformanceListCardView: View {
    let performance: PerformanceModel
    var performanceTitle: String
    var musicTitle: String
    var creator: String
    var albumCoverURL: URL?
    var image: UIImage?
    var headcount: Int
    @State private var isLoading = true

    init(performance: PerformanceModel) {
        self.performance = performance
        performanceTitle = performance.entity.title ?? "_"
        musicTitle = performance.music.title
        creator = performance.music.artistName
        albumCoverURL = performance.music.albumCoverURL
        headcount = performance.headcount
    }

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: performance.music.albumCoverURL) { phase in
                switch phase {
                case .empty:
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .onAppear {
                            isLoading = false
                        }

                case .failure:
                    Image(systemName: "exclamationmark.circle.fill")
                @unknown default:
                    Image(systemName: "exclamationmark.circle.fill")
                }
            }

            if !isLoading {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(performanceTitle)")
                            .font(.footnote)
                            .bold()
                            .opacity(0.8)
                            .lineLimit(1)
                            .padding(.bottom, 1)

                        Text("\(creator) - \(performance.music.title)")
                            .font(.caption2)
                            .opacity(0.6)
                            .lineLimit(1)
                    }

                    Text("\(performance.headcount)")
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
                .padding(.horizontal)
            }

            Spacer()
                .padding()
        }
        .frame(width: 163, height: 198)
        .background(Gradient.blueGradation2)
        .foregroundStyle(Color.monoWhite3)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
