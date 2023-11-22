// Created by byo.

import SwiftUI

struct PerformanceSettingTitleView: View {
    let step: Int
    let title: String

    var body: some View {
        HStack(spacing: 7) {
            Text("STEP \(step)")
                .foregroundStyle(Color.monoBlack)
                .font(.system(size: 11).weight(.bold))
                .kerning(-1)
                .frame(height: 22)
                .padding(.horizontal, 5)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.blueLight3)
                )
            Text(title)
                .foregroundStyle(Color.monoWhite3)
                .font(.body.weight(.bold))
        }
    }
}

#Preview {
    PerformanceSettingTitleView(step: 1, title: "대형짜기")
}
