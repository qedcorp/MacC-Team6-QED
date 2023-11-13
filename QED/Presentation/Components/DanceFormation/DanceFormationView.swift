//
//  DanceFormationView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI
import UIKit

struct DanceFormationView: View {
    var formation: Formation
    var index: Int
    var selectedIndex: Int = -1
    var width: CGFloat
    var height: CGFloat
    var isNameVisible: Bool = false
    var hideLine: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ZStack {
                    buildDanceFormationBackground()

                    if !self.hideLine {
                        buildCenterline()
                    }

                    buildSetCircleView(geometry: geometry)
                }
            }
            .frame(width: width, height: height)
            .clipped()

            buildLyric()
        }
    }

    private func buildDanceFormationBackground() -> some View {
        Rectangle()
            .fill(Color.monoNormal1)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .frame(width: width, height: height)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(
                        index == selectedIndex ? AnyShapeStyle(Color.blueLight3): AnyShapeStyle(Gradient.strokeGlass3),
                        lineWidth: 1
                    )
            )
    }

    private func buildCenterline() -> some View {
        ZStack {
            Divider()
                .background(Color.blueLight3)
            HStack {
                Divider()
                    .background(Color.blueLight3)
            }
        }
        .frame(width: width, height: height)
    }

    private func buildSetCircleView(geometry: GeometryProxy) -> some View {
        ForEach(formation.members, id: \.self) { member in
            let viewSize: UIView = {
                let view = UIView()
                view.frame.size = CGSize(width: width, height: height)
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

    private func buildLyric() -> some View {
        HStack(spacing: 3) {
            Text("\(index + 1)")
                .frame(width: 13, height: 12)
                .background(index == selectedIndex ? Color.blueLight3 : .white)
                .foregroundStyle(index == selectedIndex ? Color.monoWhite3 : Color.monoBlack)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            Text(formation.memo ?? "")
                .lineLimit(1)
                .foregroundStyle(index == selectedIndex ? Color.blueLight3 : .white)

            Spacer()
        }
        .frame(width: width)
        .font(.caption2)
        .bold()
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
