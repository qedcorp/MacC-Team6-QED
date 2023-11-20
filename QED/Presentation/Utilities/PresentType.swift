//
//  PresentType.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum PresentType: Hashable {
    case performanceSetting(PerformanceSettingViewDependency)
    case performanceLoading(PerformanceLoadingViewDependency)
    case formationSetting(FormationSettingViewDependency)
    case memberSetting(MemberSettingViewDependency)
    case performanceWatching(PerformanceWatchingViewDependency)
    case myPage(MyPageViewDependency)
    case accountInfo(AccountInfoViewDependency)
    case performanceListReading(PerformanceListReadingViewDependency)
}
