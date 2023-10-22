//
//  MemberCircleView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct MemberCircleView: View {
    var isNameVisiable: Bool
    var member: Member

    var body: some View {
        ZStack {
            if let color = member.info?.color {
                Circle()
                    .fill(Color(hex: color))
                    .frame(width: 25, height: 25)
            }
            if let name = member.info?.name {
                Text(isNameVisiable ? name.prefix(2) : "")
                    .foregroundStyle(.white)
                    .font(.caption2)
                    .bold()
            }
        }
    }
}

#Preview {
    MemberCircleView(isNameVisiable: false,
                     member: members1[0])
}
