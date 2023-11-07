//
//  ScrollObservableView.swift
//  QED
//
//  Created by changgyo seo on 11/6/23.
//

import SwiftUI

import Combine

struct ScrollObservableView: UIViewControllerRepresentable {

    var bag = Set<AnyCancellable>()
    var performance: Performance
    var action: CurrentValueSubject<ValuePurpose, Never>
    func makeUIViewController(context: Context) -> ScrollObservableViewController {
        let scrollObservableViewController = ScrollObservableViewController(performance: performance,
                                                                            action: action)
        return scrollObservableViewController
    }

    func updateUIViewController(_ uiViewController: ScrollObservableViewController, context: Context) {
    }
}

extension ScrollObservableView {

    enum ValuePurpose {
        case getOffset(CGFloat)
        case setOffset(CGFloat)
        case getSelctedIndex(Int)
        case setSelctedIndex(Int)
    }

    struct Constants {
        static let playBarHeight: CGFloat = 79
        static let formationFrame: CGSize = CGSize(width: 94, height: 61)
        static let trasitionFrame: CGSize = CGSize(width: 20, height: 35)
    }
}
