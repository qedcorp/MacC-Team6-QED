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
    var selectedIndex = 0
    var isNameVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            GeometryReader { geometry in
                ZStack {
                    buildDanceFormationBackground()
                    buildSetCircleView(geometry: geometry)
                    if index == selectedIndex {
                        buildSelectedBackground()
                    }
                }
            }
            .aspectRatio(163/108, contentMode: .fit)

            buildLyric()
        }
    }

    private func buildDanceFormationBackground() -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.monoNormal1)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(
                        index == selectedIndex ? AnyShapeStyle(Color.blueLight3): AnyShapeStyle(Gradient.strokeGlass3),
                        lineWidth: 1
                    )
            )
    }

    private func buildSetCircleView(geometry: GeometryProxy) -> some View {
        ForEach(formation.members, id: \.self) { member in
            let viewSize: UIView = {
                let view = UIView()
                view.frame.size = CGSize(width: geometry.size.width, height: geometry.size.height)
                return view
            }()

            MemberCircleView(isNameVisiable: isNameVisible,
                             member: member,
                             geometry: geometry)
            .position(
                RelativeCoordinateConverter(sizeable: viewSize)
                .getAbsoluteValue(of: member.relativePosition)
            )
        }
    }

    private func buildSelectedBackground() -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.blueLight1)
    }

    private func buildLyric() -> some View {
        HStack(alignment: .center, spacing: 3) {
            Text("\(index + 1)")
                .frame(width: 13, height: 12)
                .background(index == selectedIndex ? Color.blueLight3 : .white)
                .foregroundStyle(index == selectedIndex ? Color.monoWhite3 : Color.monoBlack)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .font(.system(size: 8))

            Text(formation.memo ?? "대형 \(index + 1)")
                .lineLimit(1)
                .foregroundStyle(index == selectedIndex ? Color.blueLight3 : .white)

            Spacer()
        }
        .font(.caption2)
        .fontWeight(.bold)
    }
}

extension Member: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Member, rhs: Member) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
