//
//  CustomFont.swift
//  QED
//
//  Created by OLING on 11/1/23.
//

import SwiftUI

// TODO: 아직 SFPro 기본 폰트만 적용 되어있어서 추가가 된다면 쓸 코드 기본 폰트만 쓰면 없어져도 될 코드
extension Font {
    enum FodiFont {
        case SFPro
        case PretendardBlack
        case PretendardBold
        case PretendardExtraLight
        case PretendardLight
        case PretendardMedium
        case PretendardRegular
        case PretendardSemiBold
        case PretendardThin

        var name: String {
            switch self {
            case .SFPro:
                return "SFPro"
            case .PretendardBlack:
                return "Pretendard-Black"
            case .PretendardBold:
                return "Pretendard-Bold"
            case .PretendardExtraLight:
                return "Pretendard-ExtraLight"
            case .PretendardLight:
                return "Pretendard-Light"
            case .PretendardMedium:
                return "Pretendard-Medium"
            case .PretendardRegular:
                return "Pretendard-Regular"
            case .PretendardSemiBold:
                return "Pretendard-SemiBold"
            case .PretendardThin:
                return "Pretendard-Thin"
            }
        }
    }

    static func fodiFont(_ type: FodiFont, size: CGFloat) -> Font {
        return .custom(type.name, size: size)
    }
}
