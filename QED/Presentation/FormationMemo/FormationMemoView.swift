// Created by byo.

import SwiftUI

struct FormationMemoView: View {
    let memo: String?

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text(memo ?? "클릭해서 가사 입력")
                .foregroundStyle(memo == nil ? .green : .black)
                .bold()
                .lineLimit(1)
            Spacer()
        }
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.gray.opacity(0.1))
        )
    }
}
