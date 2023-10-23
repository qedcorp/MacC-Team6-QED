// Created by byo.

import SwiftUI

struct MusicHeadcountView: View {
    let title: String
    let headcount: Int

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .foregroundColor(.gray)
                .font(.caption2.weight(.semibold))
            Text("\(headcount)인")
                .foregroundColor(.gray)
                .font(.caption2)
                .frame(height: 20)
                .padding(.horizontal, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(.gray.opacity(0.1))
                )
        }
    }
}

#Preview {
    MusicHeadcountView(title: "", headcount: 0)
}
