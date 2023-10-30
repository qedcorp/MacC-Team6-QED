// Created by byo.

import SwiftUI

struct ZoomableView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @StateObject private var viewModel = ZoomableViewModel()

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .gesture(
                    DragGesture()
                        .onChanged {
                            viewModel.updateTransition($0)
                        }
                        .onEnded { _ in
                            viewModel.updateLastTransitionSize()
                        }
                )
            content()
                .scaleEffect(viewModel.zoomScaleSize)
                .offset(viewModel.transitionSize)
        }
        .gesture(
            MagnificationGesture()
                .onChanged {
                    viewModel.updateZoomScale($0)
                }
        )
    }
}
