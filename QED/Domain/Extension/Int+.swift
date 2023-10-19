//
//  TimeInterval+.swift
//  QED
//
//  Created by chaekie on 10/20/23.
//

import Foundation

extension Int {
    var msToTimeString: String {
        let overS = self / 1000
        let minute = overS / 60
        let second = overS % 60
        return String(format: "%d:%02d", minute, second)
    }
}
