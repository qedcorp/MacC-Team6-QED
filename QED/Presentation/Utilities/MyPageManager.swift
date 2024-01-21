//
//  MyPageManager.swift
//  QED
//
//  Created by chaekie on 11/9/23.
//

import Foundation

enum MyPageList: String, CaseIterable {
    case termsAndConditions
    case customerSupport

    var id: String { return title }

    var title: String {
        switch self {
        case .termsAndConditions: "약관 및 정책"
        case .customerSupport: "FODI 고객지원"
        }
    }

    var label: [Label] {
        switch self {
        case .termsAndConditions:
            return [.terms, .personalInfo]
        case .customerSupport:
            return [.appReview, .appFeedback]
        }
    }

    enum Label: String {
        case terms = "이용약관"
        case personalInfo = "개인정보 처리 방침"
        case appReview = "앱스토어 평가하기"
        case appFeedback = "개선의견 남기기"
    }
}
