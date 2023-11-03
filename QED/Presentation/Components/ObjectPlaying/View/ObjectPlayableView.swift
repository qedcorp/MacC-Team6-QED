//
//  ObjectPlayableView.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import SwiftUI

struct ObjectPlayableView: UIViewControllerRepresentable {

    let controller: ObjectPlayableViewController

    func makeUIViewController(context: Context) -> ObjectPlayableViewController {
        controller
    }

    func updateUIViewController(_ uiViewController: ObjectPlayableViewController, context: Context) {
    }
}
