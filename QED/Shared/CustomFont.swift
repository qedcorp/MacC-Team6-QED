//
//  CustomFont.swift
//  QED
//
//  Created by OLING on 11/1/23.
//

import SwiftUI

//TODO: 아직 SFPro 기본 폰트만 적용 되어있어서 추가가 된다면 쓸 코드 기본 폰트만 쓰면 없어져도 될 코드
extension Font {
    enum FodiFont {
        case SFPro
        case newFont
        
        var name: String {
            switch self {
            case .SFPro:
                return "SFPro"
            case .newFont:
                return "newFont"
            }
        }
    }
    
    static func fodiFont(_ type: FodiFont, size: CGFloat) -> Font {
        return .custom(type.name, size: size)
    }
}
