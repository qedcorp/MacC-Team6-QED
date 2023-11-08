// Created by byo.

import SwiftUI

struct ZoomableView<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @StateObject private var viewModel = ZoomableViewModel()

    var body: some View {
        ZStack {
            Color.build(hex: .unknown0)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
                .gesture(
                    DragGesture()
                        .onChanged {
                            viewModel.updateTransition($0)
                        }
                        .onEnded { _ in
                            viewModel.updateLastValues()
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
                .onEnded { _ in
                    viewModel.updateLastValues()
                }
        )
    }
}
