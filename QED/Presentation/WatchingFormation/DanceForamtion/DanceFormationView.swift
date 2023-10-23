//
//  DanceFormationView.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import SwiftUI
import SpriteKit

struct DanceFormationView: View {

    @ObservedObject var viewmodel = DetailFormationViewModel()

    var body: some View {
        VStack {
            SpriteView(scene: self.viewmodel.scene)
                .frame(width: 350, height: 220)
                .onTapGesture {
                    viewmodel.play()
                }

            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.red)
                .onTapGesture {
                    viewmodel.forward()
                }

            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.green)
                .onTapGesture {
                    viewmodel.pause()
                }

            Rectangle()
                .frame(width: 100, height: 100)
                .foregroundStyle(.green)
                .onTapGesture {
                    viewmodel.backward()
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

#Preview {
    DanceFormationView()
}
