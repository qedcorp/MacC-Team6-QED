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
        VStack(spacing: 0) {
            TimeAndLyric(formation: formation)
            danceFormation
        }
    }

    private var danceFormation: some View {
        ZStack {
            danceFormationBackground
            if !self.hideLine {
                centerline
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
    }

    private var danceFormationBackground: some View {
        Rectangle()
            .fill(Color(.systemGray6))
            .clipShape(
                .rect(bottomLeadingRadius: 12,
                      bottomTrailingRadius: 12))
    }

    private var centerline: some View {
        ZStack {
            Divider()
                .background(.green)
            HStack {
                Divider()
                    .background(.green)
            }
        }
    }
}

private struct TimeAndLyric: View {
    var formation: Formation

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .clipShape(
                    .rect(topLeadingRadius: 12,
                          topTrailingRadius: 12))
                .frame(height: 30)
            HStack {
//                if let startMs = formation.startMs {
//                    Text(startMs.msToTimeString)
//                }
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
