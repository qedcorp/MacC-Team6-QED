// Created by byo.

import SwiftUI

struct MemoFormView: View {
    @State var memo: String
    let onSubmit: (String) -> Void
    let onDismiss: () -> Void
    @State private var animation: AnimationType = .appear

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    animation = .disappear
                    onDismiss()
                }
            VStack(spacing: 124) {
                TextField("클릭해서 가사 입력", text: $memo)
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
                    onSubmit(memo)
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
        }
    }

    private enum AnimationType {
        case appear
        case appeared
        case disappear
    }
}
