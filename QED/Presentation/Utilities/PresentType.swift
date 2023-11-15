//
//  PresentType.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum PresentType: Hashable {
    case performanceSetting
    case performanceLoading(PerformanceLoadingTransferModel)
    case performanceWatching(PerformanceWatchingTransferModel)
    case myPage
    case performanceListReading([Performance])
    case formationSetting(Performance, Int? = nil)
    case memberSetting(MemberSettingTransferModel)
}
