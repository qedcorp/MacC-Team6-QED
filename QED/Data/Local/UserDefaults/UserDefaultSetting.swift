//
//  UserDefaultSetting.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum UserDefaultsSetting {

    @UserDefaultsWrapper(key: "isTouchingToAddMemeber", defaultValue: false)
    static var isTouchingToAddMemeber

    @UserDefaultsWrapper(key: "isAdddingPreset", defaultValue: false)
    static var isAddPreset

    @UserDefaultsWrapper(key: "isDragingGroup", defaultValue: false)
    static var isDragingGroup

    @UserDefaultsWrapper(key: "isSettingColor", defaultValue: false)
    static var isSettingColor
}
