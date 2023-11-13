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
        static let formationFrame: CGSize = CGSize(width: 96, height: 61)
        static let trasitionFrame: CGSize = CGSize(width: 32, height: 35)
    }

    enum FrameInfo: Equatable {
        case formation(index: Int = 0)
        case transition(index: Int = 0)

        var id: String {
            switch self {
            case .formation:
                return "FORMATION"
            case .transition:
                return "TRANSITION"
            }
        }

        var index: Int {
            switch self {
            case let .formation(index: index):
                return index
            case let .transition(index: index):
                return index
            }
        }

        func isSameFrame(_ otherInfo: FrameInfo) -> Bool {
            return self.id == otherInfo.id
        }

        static func ==(lhs: FrameInfo, rhs: FrameInfo) -> Bool {
            return lhs.index == rhs.index && lhs.id == rhs.id
        }
    }
}
