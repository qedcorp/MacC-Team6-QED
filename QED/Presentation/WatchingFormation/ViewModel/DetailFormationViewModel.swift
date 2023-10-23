//
//  DetailFormationViewMoel.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import Foundation

class DetailFormationViewModel: ObservableObject {
    @Published var selcetedFormation: Formation?
    @Published var memo: String?

    func getCurrentFormation(formation: Formation) {
        selcetedFormation = formation
    }

    func play() {}

    func pause() {}

    func backward(performance: Performance) {
        for (index, formation) in performance.formations.enumerated() {
            if formation == selcetedFormation && index > 0 {
                selcetedFormation = performance.formations[index - 1]
            }
        }
    }

    func forward(performance: Performance) {
        for (index, formation) in performance.formations.enumerated() {
            if formation == selcetedFormation && index < performance.formations.count - 1 {
                selcetedFormation = performance.formations[index + 1]
            }
        }
    }

}
