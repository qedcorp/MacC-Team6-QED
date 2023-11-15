//
//  Tutorial.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum Tutorial {
    case isTouchingToAddMemeber
    case isAddPreset
    case isDragingGroup
    case isSettingColor

    var isActivate: Bool {
        switch self {
        case .isTouchingToAddMemeber:
            return UserDefaultsSetting.isTouchingToAddMemeber
        case .isAddPreset:
            return UserDefaultsSetting.isAddPreset
        case .isDragingGroup:
            return UserDefaultsSetting.isDragingGroup
        case .isSettingColor:
            return UserDefaultsSetting.isSettingColor
        }
    }

    var message: String {
        switch self {
        case .isTouchingToAddMemeber:
            return "화면을 터치해 인원을 추가해 보세요!"
        case .isAddPreset:
            return "더 간편하게 프리셋을 선택해보세요"
        case .isDragingGroup:
            return "선택 혹은 드래그 이동할 수 있어요"
        case .isSettingColor:
            return "인물의 색상을 지정하세요"
        }
    }

    var position: CGPoint {
        switch self {
        case .isTouchingToAddMemeber:
            return CGPoint(x: 194.5, y: 277)
        case .isAddPreset:
            return CGPoint(x: 152, y: 602)
        case .isDragingGroup:
            return CGPoint(x: 194.5, y: 277)
        case .isSettingColor:
            return CGPoint(x: 194, y: 231)
        }
    }
}
