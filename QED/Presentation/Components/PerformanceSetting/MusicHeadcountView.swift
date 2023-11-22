// Created by byo.

import SwiftUI

struct MusicHeadcountView: View {
    let title: String
    let headcount: Int

    var body: some View {
        HStack(spacing: 7) {
            Text(title == "_" ? "선택한 노래없음" : title)
                .foregroundStyle(Color.monoWhite3)
                .font(.caption)
            Text("\(headcount)인")
                .foregroundStyle(Color.monoBlack)
                .font(.system(size: 10).weight(.semibold))
                .frame(height: 16)
                .padding(.horizontal, 7)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.monoWhite3)
                )
        }
    }
}

#Preview {
    MusicHeadcountView(title: "New Jeans", headcount: 5)
}
