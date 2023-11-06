//
//  DanceFormationView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct DanceFormationView: View {
    var formation: Formation
    var index: Int
    var isNameVisible: Bool = false
    var hideLine: Bool = false

    var body: some View {
        ZStack {
            danceFormationBackground()
            if !self.hideLine {
                centerline()
            }
            GeometryReader { geometry in
                ForEach(formation.members, id: \.info.self) { member in
                    MemberCircleView(isNameVisiable: isNameVisible,
                                     member: member,
                                     geometry: geometry)
                    .position(
                        RelativeCoordinateConverter(sizeable: geometry)
                                                    .getAbsoluteValue(of: member.relativePosition)
                    )
                }
            }
        }
        .clipped()
    }

    private func danceFormationBackground() -> some View {
        Rectangle()
            .fill(Color.monoNormal1)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private func centerline() -> some View {
        ZStack {
            Divider()
                .background(.green)
            HStack {
                Divider()
                    .background(.green)
            }
        }
    }

    private func timeAndLyric() -> some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .clipShape(
                    .rect(topLeadingRadius: 12,
                          topTrailingRadius: 12))
                .frame(height: 30)
            HStack {
                if let memo = formation.memo {
                    Text(memo)
                }
            }
            .padding(.horizontal)
            .lineLimit(1)
            .foregroundStyle(.white)
            .bold()
        }
    }
}

#Preview {
    DanceFormationView(formation: mockFormations[0], index: 0)
}
