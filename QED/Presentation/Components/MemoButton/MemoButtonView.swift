// Created by byo.

import SwiftUI

struct MemoButtonView: View {
    let memo: String?
    let isHighlighted: Bool
    private let cornerRadius: CGFloat = 6

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(memo ?? "탭해서 가사 입력")
                .foregroundStyle(isHighlighted || hasMemo ? Color.monoWhite3 : Color.monoNormal2)
                .font(.headline.weight(.regular))
                .lineLimit(1)
            Spacer()
        }
        .frame(height: 64)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isHighlighted ? Color.blueLight2 : Color.build(hex: .memoBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)
        )
    }

    private var hasMemo: Bool {
        memo != nil
    }
}

#Preview {
    MemoButtonView(memo: "Pop pop", isHighlighted: false)
}
