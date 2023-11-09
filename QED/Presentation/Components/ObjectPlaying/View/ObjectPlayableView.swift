//
//  ObjectPlayableView.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import SwiftUI

struct ObjectPlayableView: UIViewControllerRepresentable {

    let movementsMap: MovementsMap
    let totalCount: Int
    @Binding var offset: CGFloat

    func makeUIViewController(context: Context) -> ObjectPlayableViewController {
        return ObjectPlayableViewController(movementsMap: movementsMap, totalCount: totalCount)
    }

    func updateUIViewController(_ uiViewController: ObjectPlayableViewController, context: Context) {
        uiViewController.setNewMemberFormation(offset: offset)
    }
}
