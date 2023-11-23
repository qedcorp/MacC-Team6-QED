// Created by byo.

import SwiftUI

struct MemoFormView: View {
    private enum FocusType {
        case memoField
    }

    @State var memo: String
    let onComplete: (String) -> Void
    private let cornerRadius: CGFloat = 8
    @FocusState private var focusedField: FocusType?

    var body: some View {
        ZStack {
            Color.build(hex: .modalBackground)
                .ignoresSafeArea()
                .onTapGesture {
                    complete()
                }
            TextField("", text: $memo)
                .focused($focusedField, equals: .memoField)
                .submitLabel(.done)
                .foregroundStyle(Color.monoWhite3)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(height: 64)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.monoNormal1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.strokeGlass2)
                )
                .padding(.horizontal, 24)
                .onSubmit {
                    complete()
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            focusedField = .memoField
        }
    }

    private func complete() {
        guard !memo.isEmpty else {
            return
        }
        focusedField = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            onComplete(memo)
        }
    }
}

#Preview {
    ZStack {
        MainView()
        MemoFormView(memo: "") { _ in }
    }
}
