// Created by byo.

import SwiftUI

struct MemoButtonView: View {
    let memo: String?

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(memo ?? "탭해서 가사 입력")
                .foregroundStyle(hasMemo ? Color.monoWhite3 : Color.monoNormal2)
                .font(.title2.weight(.bold))
                .lineLimit(1)
            Spacer()
        }
        .frame(height: 64)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.monoNormal1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)
        )
    }

    private var hasMemo: Bool {
        memo != nil
    }
}

#Preview {
    MemoButtonView(memo: "Pop pop")
}
