//
//  UserDefaultSetting.swift
//  QED
//
//  Created by changgyo seo on 11/15/23.
//

import Foundation

enum UserDefaultsSetting {

    @UserDefaultsWrapper(key: "isTouchingToAddMemeber", defaultValue: true)
    static var isTouchingToAddMemeber

    @UserDefaultsWrapper(key: "isAdddingPreset", defaultValue: true)
    static var isAddPreset

    @UserDefaultsWrapper(key: "isDragingGroup", defaultValue: true)
    static var isDragingGroup

    @UserDefaultsWrapper(key: "isSettingColor", defaultValue: true)
    static var isSettingColor
}
