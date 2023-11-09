//
//  MyPageManager.swift
//  QED
//
//  Created by chaekie on 11/9/23.
//

import Foundation

enum MyPageList: String, CaseIterable {
    case defaultInfo
    case termsAndConditions
    case manageAccount

    var id: String { return title }

    var title: String {
        switch self {
        case .defaultInfo: "기본 정보"
        case .termsAndConditions: "약관 및 정책"
        case .manageAccount: "계정 관리"
        }
    }

    var label: [Label] {
        switch self {
        case .defaultInfo:
            return [.name, .email]
        case .termsAndConditions:
            return [.terms, .personalInfo]
        case .manageAccount:
            return [.logout, .withdrawal]
        }
    }

    enum Label: String {
        case name = "이름"
        case email = "가입상태"
        case terms = "이용약관"
        case personalInfo = "개인정보 처리 방침"
        case logout = "로그아웃"
        case withdrawal = "회원 탈퇴"
    }
}
