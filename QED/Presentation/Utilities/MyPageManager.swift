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
            return [.announcement, .appReview]
        }
    }

    enum Label: String {
        case terms = "이용약관"
        case personalInfo = "개인정보 처리 방침"
        case announcement = "공지사항"
        case appReview = "앱 평가하기"
    }
}
