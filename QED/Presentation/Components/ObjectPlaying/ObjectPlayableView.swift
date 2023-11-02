//
//  ObjectPlayableView.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import SwiftUI

struct ObjectPlayableView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ObjectPlayableViewController {
        ObjectPlayableViewController(index: 0)
    }

    func updateUIViewController(_ uiViewController: ObjectPlayableViewController, context: Context) {
    }
}

