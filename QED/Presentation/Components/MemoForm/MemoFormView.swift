// Created by byo.

import SwiftUI

struct MemoFormView: View {
    private enum AnimationType {
        case appear
        case appeared
        case disappear
    }

    private enum FocusType {
        case memoField
    }

    @State var memo: String
    let onComplete: (String) -> Void
    @State private var animation: AnimationType = .appear
    @FocusState private var focusedField: FocusType?

    var body: some View {
        ZStack {
            Color.monoBlack.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    complete()
                }
            TextField("", text: $memo)
                .focused($focusedField, equals: .memoField)
                .foregroundStyle(Color.monoBlack)
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)
                .frame(height: 72)
                .background(
                    RoundedRectangle(cornerRadius: 8).fill(.white)
                )
                .padding(.horizontal, 20)
        }
        .opacity(animation == .appeared ? 1 : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut, value: animation)
        .onAppear {
            animation = .appeared
            focusedField = .memoField
        }
    }

    private func complete() {
        guard !memo.isEmpty else {
            return
        }
        animation = .disappear
        onComplete(memo)
    }
}
