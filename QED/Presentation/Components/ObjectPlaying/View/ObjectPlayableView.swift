//
//  ObjectPlayableView.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import SwiftUI

struct ObjectPlayableView: UIViewControllerRepresentable {

    let movementsMap: MovementsMap
    @Binding var index: CGFloat

    func makeUIViewController(context: Context) -> ObjectPlayableViewController {
        return ObjectPlayableViewController(movementsMap: movementsMap)
    }

    func updateUIViewController(_ uiViewController: ObjectPlayableViewController, context: Context) {
        let temp = Int(index)
        uiViewController.setNewMemberFormation(index: temp)
    }
}
