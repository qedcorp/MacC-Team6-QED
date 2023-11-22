//
//  CustomFont.swift
//  QED
//
//  Created by OLING on 11/1/23.
//

import SwiftUI

extension Font {
    enum FodiFont {
        case SFPro
        case pretendardBlack
        case pretendardBold
        case pretendardExtraLight
        case pretendardLight
        case pretendardMedium
        case pretendardRegular
        case pretendardSemiBold
        case pretendardThin

        var name: String {
            switch self {
            case .SFPro:
                return "SFPro"
            case .pretendardBlack:
                return "Pretendard-Black"
            case .pretendardBold:
                return "Pretendard-Bold"
            case .pretendardExtraLight:
                return "Pretendard-ExtraLight"
            case .pretendardLight:
                return "Pretendard-Light"
            case .pretendardMedium:
                return "Pretendard-Medium"
            case .pretendardRegular:
                return "Pretendard-Regular"
            case .pretendardSemiBold:
                return "Pretendard-SemiBold"
            case .pretendardThin:
                return "Pretendard-Thin"
            }
        }
    }
    static func fodiFont(_ type: FodiFont, size: CGFloat) -> Font {
        return.custom(type.name, size: size)
    }
}
