//
//  View+.swift
//  QED
//
//  Created by changgyo seo on 11/30/23.
//

import SwiftUI

extension View {
    func showModal<Modal: View>(_ condition: Bool,
                   modal: @escaping () -> Modal) -> some View {
        modifier(ModalTypeView(
            isPresented: condition,
            modal: modal)
        )
    }
}

struct ModalTypeView<Modal: View>: ViewModifier {
    var isPresented: Bool
    @ViewBuilder var modal: () -> Modal
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                    modal()
                    .opacity(isPresented ? 1 : 0)
                    .offset(y: isPresented ? 0 : 1000)
            }
    }
}
