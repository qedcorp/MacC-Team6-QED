//
//  TutorialView.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import SwiftUI

struct TutorialView: View {

    var words: String

    var body: some View {
        Text(words)
            .foregroundStyle(.white)
            .font(.system(size: 17))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background {
                Capsule()
                    .foregroundStyle(Color.blueLight2)
            }

    }
}
