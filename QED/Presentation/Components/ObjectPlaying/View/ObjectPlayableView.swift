//
//  ObjectPlayableView.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import SwiftUI

struct ObjectPlayableView: UIViewControllerRepresentable {

    let movementsMap: MovementsMap
    @Binding var index: Int

    func makeUIViewController(context: Context) -> ObjectPlayableViewController {
        ObjectPlayableViewController(movementsMap: movementsMap)
    }

    func updateUIViewController(_ uiViewController: ObjectPlayableViewController, context: Context) {
        uiViewController.setNewMemberFormation(index: index)
    }
}
