//
//  DetailFormationViewMoel.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import Foundation

class DetailFormationViewMoel: ObservableObject {
//    var currentFormation: Formation

    func play() {}

    func pause() {}

    func backward(performance: Performance, currentFormation: Formation) -> Formation {
        var beforeFormation = currentFormation
        for (index, formation) in performance.formations.enumerated() {
            if formation == currentFormation && index > 0 {
                beforeFormation = performance.formations[index - 1]
            }
        }
        return beforeFormation
    }

    func forward(performance: Performance, currentFormation: Formation) -> Formation {
        var nextFormation = currentFormation
        for (index, formation) in performance.formations.enumerated() {
            if formation == currentFormation && index < performance.formations.count {
                nextFormation = performance.formations[index + 1]
            }
        }
        return nextFormation
    }

    func selectFormation(currentFormation: Formation, selectdFormation: Formation) {

    }
}
