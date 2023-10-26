//
//  PlayableDanceFormationView.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import SwiftUI
import SpriteKit

struct PlayableDanceFormationView: View {
    @ObservedObject var viewmodel: DetailFormationViewModel

    var body: some View {
        ZStack {
            SpriteView(scene: self.viewmodel.scene)
                .frame(width: 350, height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
