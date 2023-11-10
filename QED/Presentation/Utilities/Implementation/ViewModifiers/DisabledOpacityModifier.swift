// Created by byo.

import SwiftUI

struct DisabledOpacityModifier: ViewModifier {
    let isDisabled: Bool
    let disabledOpacity: Double

    func body(content: Content) -> some View {
        content
            .opacity(isDisabled ? disabledOpacity : 1)
            .disabled(isDisabled)
    }
}
