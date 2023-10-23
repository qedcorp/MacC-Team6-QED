//
//  DanceFormationView.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import SwiftUI
import SpriteKit

struct DanceFormationView: View {

    @ObservedObject var viewmodel: DetailFormationViewModel

    var body: some View {
        VStack {
            SpriteView(scene: self.viewmodel.scene)
                .frame(width: 350, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture {
                    viewmodel.play()
                }
        }
    }

    @ViewBuilder
    func danceFormationBackground(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Rectangle()
                .fill(Color(.systemGray6))
                .clipShape(
                    .rect(topLeadingRadius: 12,
                          topTrailingRadius: 12))
            Rectangle()
                .frame(width: 1, height: height)
            Rectangle()
                .frame(width: width, height: 1)
        }
    }
}
