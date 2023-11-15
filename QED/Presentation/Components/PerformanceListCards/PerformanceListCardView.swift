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
    @State private var isMusic = false

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
                .frame(height: 180)

                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(performanceTitle)")
                            .font(.footnote)
                            .bold()
                            .opacity(0.8)
                            .lineLimit(1)
                            .padding(.bottom, 1)

                        Text("\(musicTitle)")
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
                .background {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 61)
                        .foregroundStyle(LinearGradient(
                            stops: [
                            Gradient.Stop(color: Color(red: 0.45, green: 0.87, blue: 0.98).opacity(0.4), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.04, green: 0.8, blue: 1).opacity(0.4), location: 1.00)
                            ],
                            startPoint: UnitPoint(x: -0.01, y: 0),
                            endPoint: UnitPoint(x: 0.97, y: 0.94)
                            )
                            )
                            .background(.white.opacity(0.4))
                }
                .padding(.top, 5)
                .padding(.leading, 20)
                .padding(.trailing, 10)

                Spacer()
                    .padding()

            }
            .frame(width: 163, height: 198)
            .background(Gradient.blueGradation2)
            .foregroundStyle(Color.monoWhite3)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    PerformanceListCardView(performance: mockPerformance1)
}
