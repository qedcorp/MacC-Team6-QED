// Created by byo.

import SwiftUI

struct MemberInfoChangeView: View {
    @Binding var name: String
    let color: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            VStack(spacing: 36) {
                HStack {
                    Text("인물수정")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Button("X") {
                        onDismiss()
                    }
                }
                HStack(spacing: 14) {
                    Circle()
                        .fill(Color(hex: color))
                        .frame(maxHeight: .infinity)
                        .aspectRatio(contentMode: .fit)
                    TextField("", text: $name)
                        .font(.title2)
                        .bold()
                        .padding(.horizontal, 20)
                        .frame(maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(radius: 2)
                        )
                }
                .frame(height: 66)
            }
            .padding(.horizontal, 26)
            .padding(.top, 26)
            .padding(.bottom, 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
            )
            .padding(.horizontal, 22)
        }
    }
}
