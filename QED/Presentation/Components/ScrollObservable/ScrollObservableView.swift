//
//  ScrollObservableView.swift
//  QED
//
//  Created by changgyo seo on 11/6/23.
//

import SwiftUI

struct ScrollObservableView<ContentView: View>: UIViewControllerRepresentable {

    @Binding var offset: CGFloat
    var content: (() -> ContentView)?

    func makeUIViewController(context: Context) -> ScrollObservableViewController {
        let view = UIHostingController(rootView: content!()).view!
        return ScrollObservableViewController(offset: $offset, content: view)
    }

    func updateUIViewController(_ uiViewController: ScrollObservableViewController, context: Context) {
//        let view = UIHostingController(rootView: content!()).view!
//        uiViewController.setOffset(offset, view)
    }
}
