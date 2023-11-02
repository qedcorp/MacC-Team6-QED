// Created by byo.

import SwiftUI

struct DisabledOpacityModifier: ViewModifier {
    let isDisabled: Bool
    let disabledOpacity: Double

    func body(content: Content) -> some View {
        content
            .animation(.easeInOut, value: isDisabled)
            .opacity(isDisabled ? disabledOpacity : 1)
            .disabled(isDisabled)
    }
}
