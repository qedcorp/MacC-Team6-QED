//
//  PerformanceListCardView.swift
//  QED
//
//  Created by OLING on 10/28/23.
//

import SwiftUI

struct PerformanceListCardView: View {
    let performance: PerformanceModel
    var title: String
    var creator: String
    var albumCoverURL: URL?
    var image: UIImage?
    @State private var isLoading = true

    init(performance: PerformanceModel) {
        self.performance = performance
        title = performance.music.title
        creator = performance.music.artistName
        albumCoverURL = performance.music.albumCoverURL
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
                VStack(alignment: .leading) {
                    Text("\(performance.music.title)")
                        .font(.footnote)
                        .bold()
                        .opacity(0.8)
                    Text("\(creator)")
                        .font(.caption2)
                        .opacity(0.6)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .frame(width: 160, height: 198)
        .background(Color(.systemGray6))
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
