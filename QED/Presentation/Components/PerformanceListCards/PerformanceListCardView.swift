//
//  PerformanceListCardView.swift
//  QED
//
//  Created by OLING on 10/28/23.
//

import SwiftUI

struct PerformanceListCardView: View {

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
        .frame(width: 160, height: 198)
        .background(Color(.systemGray6))
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// #Preview {
//    PerformanceListCardView(performance: performance)
// }
