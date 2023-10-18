//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import Foundation

class PerformanceSettingViewModel: ObservableObject {
    @Published var headcount = 2

    func decrementHeadcount() {
        if headcount > 2 {
            headcount -= 1
        }
    }

    func incrementHeadcount() {
        if headcount < 13 {
            headcount += 1
        }
    }
}
