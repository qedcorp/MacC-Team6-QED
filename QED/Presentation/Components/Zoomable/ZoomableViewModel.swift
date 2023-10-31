// Created by byo.

import SwiftUI

@MainActor
class ZoomableViewModel: ObservableObject {
    static let defaultZoomScale: CGFloat = 2
    static let defaultZoomScaleRange: ClosedRange<CGFloat> = 1 ... 3

    let zoomScaleRange: ClosedRange<CGFloat>
    @Published private(set) var zoomScale = defaultZoomScale
    @Published private(set) var transitionSize: CGSize = .zero
    private var lastZoomScale = defaultZoomScale
    private var lastTransitionSize: CGSize = .zero

    init(zoomScaleRange: ClosedRange<CGFloat> = defaultZoomScaleRange) {
        self.zoomScaleRange = zoomScaleRange
    }

    var zoomScaleSize: CGSize {
        CGSize(
            width: zoomScale,
            height: zoomScale
        )
    }

    func updateZoomScale(_ value: MagnificationGesture.Value) {
        let value = lastZoomScale + (value - 1) * 2
        zoomScale = min(max(value, zoomScaleRange.lowerBound), zoomScaleRange.upperBound)
    }

    func updateTransition(_ value: DragGesture.Value) {
        transitionSize = .init(
            width: lastTransitionSize.width + value.translation.width,
            height: lastTransitionSize.height + value.translation.height
        )
    }

    func updateLastValues() {
        lastZoomScale = zoomScale
        lastTransitionSize = transitionSize
    }
}
