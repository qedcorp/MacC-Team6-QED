// Created by byo.

import SwiftUI

struct ToastContainerView: View {
    @StateObject private var viewModel = ToastContainerViewModel.shared

    var body: some View {
        VStack {
            Spacer()
            if let message = viewModel.currentMessage, viewModel.isMessagePresentable {
                buildToastView(message: message)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    private func buildToastView(message: String) -> some View {
        HStack(spacing: 10) {
            Image("sparkles")
                .frame(width: 21, height: 27)
            Text(message)
                .foregroundStyle(Color.monoWhite3)
                .font(.headline.weight(.bold))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
        .background(
            Color.blueLight2
                .background(.ultraThinMaterial)
        )
        .mask {
            RoundedRectangle(cornerRadius: 10)
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 131)
        .transition(
            .opacity
                .combined(with: .offset(y: 32))
                .animation(.interpolatingSpring)
        )
    }
}

#Preview {
    ToastContainerView()
}
