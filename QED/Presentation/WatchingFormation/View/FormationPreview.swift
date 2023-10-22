//
//  FormationPreview.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct FormationPreview: View {
    var isNameVisiable: Bool
    var formation: Formation
    @State var isSelected = false

    var body: some View {
        VStack(spacing: 0) {
            danceFormation
            TimeAndLyric(formation: formation)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.green, lineWidth: isSelected ? 2 : 0)
        )
    }

    private var danceFormation: some View {
        ZStack {
            danceFormationBackground
            centerline
            GeometryReader { geometry in
                ForEach(formation.members, id: \.info.self) { member in
                    MemberCircleView(isNameVisiable: isNameVisiable,
                                 member: member)
                    .position(CGPoint(x: CGFloat(member.relativePosition.x)*geometry.size.width*0.001, y: CGFloat(member.relativePosition.y)*geometry.size.height*0.001))
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeIn(duration: 0.1)) {
                isSelected.toggle()
                //           TODO: 상세화면으로 이동
            }
        }
    }

    private var danceFormationBackground: some View {
        Rectangle()
            .fill(Color(.systemGray6))
            .aspectRatio(35/22, contentMode: .fit)
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
    FormationPreview(isNameVisiable: false, formation: mockFormations[0])
}
