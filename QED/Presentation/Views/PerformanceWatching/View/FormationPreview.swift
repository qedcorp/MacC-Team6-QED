//
//  FormationPreview.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct FormationPreview: View {
    var formation: Formation
    var index: Int
    var isNameVisiable: Bool = false
    var hideLine: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            danceFormation
            TimeAndLyric(formation: formation)
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
                    MemberCircleView(isNameVisiable: isNameVisiable,
                                     member: member,
                                     geometry: geometry)
                    .position(
                        RelativePositionConverter(sizeable: geometry)
                            .getAbsolutePosition(of: member.relativePosition)
                    )
                }
            }
        }
    }

    private var danceFormationBackground: some View {
        Rectangle()
            .fill(Color(.systemGray6))
            .clipShape(
                .rect(topLeadingRadius: 12,
                      topTrailingRadius: 12))
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
                    .rect(bottomLeadingRadius: 12,
                          bottomTrailingRadius: 12))
                .frame(height: 30)
            HStack {
                if let startMs = formation.startMs {
                    Text(startMs.msToTimeString)
                }
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
    FormationPreview(formation: mockFormations[0], index: 0)
}
