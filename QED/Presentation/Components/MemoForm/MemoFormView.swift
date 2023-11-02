// Created by byo.

import SwiftUI

struct MemoFormView: View {
    @State var memo: String
    let onComplete: (String) -> Void
    @State private var animation: AnimationType = .appear
    @FocusState private var focusedField: FocusType?

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    animation = .disappear
                    onComplete(memo)
                }
            VStack(spacing: 124) {
                TextField("클릭해서 가사 입력", text: $memo)
                    .focused($focusedField, equals: .memoField)
                    .font(.system(size: 26).bold())
                    .multilineTextAlignment(.center)
                    .frame(height: 66)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.white)
                            .shadow(radius: 2)
                    )
                    .padding(.horizontal, 22)
                Button {
                    animation = .disappear
                    onComplete(memo)
                } label: {
                    ZStack {
                        Capsule()
                            .fill(memo.isEmpty ? .gray : .green)
                            .frame(width: 94, height: 54)
                            .animation(.easeInOut, value: memo)
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .opacity(animation == .appeared ? 1 : 0)
        .animation(.easeInOut, value: animation)
        .onAppear {
            animation = .appeared
            focusedField = .memoField
        }
    }

    private enum AnimationType {
        case appear
        case appeared
        case disappear
    }

    private enum FocusType {
        case memoField
    }
}
