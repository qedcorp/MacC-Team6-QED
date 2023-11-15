//
//  PresentType.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum PresentType: Hashable {
    case performanceSetting
    case performanceWatching(Performance)
    case myPage
    case performanceListReading([Performance])
    case formationSetting(Performance)
    // case memberSetting
}