//
//  PerformanceSettingViewModel.swift
//  QED
//
//  Created by OLING on 10/17/23.
//

import Foundation

struct PerformanceSettingViewModel {
    var headcount = 2

    mutating func decreaseHeadcount() {
        if headcount > 2 {
            headcount -= 1
        }
    }

    mutating func increaseHeadcount() {
        if headcount < 13 {
            headcount += 1
        }
    }
}
