//
//  PresentType.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum PresentType: Hashable {
    case performanceSetting
    case performanceLoading(PerformanceLoadingData)
    case performanceWatching(Performance, Bool)
    case myPage
    case performanceListReading([Performance])
    case formationSetting(Performance, Int? = nil)
    // case memberSetting
}
