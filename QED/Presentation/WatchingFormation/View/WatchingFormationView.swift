//
//  WatchingFormationView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct WatchingFormationView: View {
    @Environment(\.dismiss) private var dismiss
    @State var title = "PINK VENOM"
    @State var headcount = 4
    @State var isNameVisiable = false
    @State var isAddVisible = false
    var members1 = [Member(relativePosition: RelativePosition(x: 100, y: 500),
                           info: Member.Info(name: "쥬쥬", color: "F06292")),
                    Member(relativePosition: RelativePosition(x: 300, y: 500),
                           info: Member.Info(name: "웅", color: "85C1E9")),
                    Member(relativePosition: RelativePosition(x: 500, y: 500),
                           info: Member.Info(name: "키오오", color: "C39BD3")),
                    Member(relativePosition: RelativePosition(x: 700, y: 500),
                           info: Member.Info(name: "올링링링", color: "F7DC6F"))]
    var members2 = [Member(relativePosition: RelativePosition(x: 500, y: 200),
                           info: Member.Info(name: "쥬쥬", color: "F06292")),
                    Member(relativePosition: RelativePosition(x: 500, y: 500),
                           info: Member.Info(name: "웅", color: "85C1E9")),
                    Member(relativePosition: RelativePosition(x: 500, y: 700),
                           info: Member.Info(name: "키오오", color: "C39BD3")),
                    Member(relativePosition: RelativePosition(x: 500, y: 900),
                           info: Member.Info(name: "올링링링", color: "F7DC6F"))]
    var formations: [Formation]

    init() {
        formations = [Formation(members: members1, startMs: 0, memo: "킥인더도어"),
                      Formation(members: members2, startMs: 130000, memo: "눈 감고 팝팝")]
    }

    var body: some View {
        VStack(spacing: 15) {
            titleAndHeadcount
            togglingMemberName
            FormationScrollView(isNameVisiable: isNameVisiable,
                                formations: formations,
                                isAddVisible: isAddVisible)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("전체 대형 보기")
        .toolbar {
            leftItem
            rightItem
        }
    }

    private var titleAndHeadcount: some View {
        HStack {
            Text("\(title)")
                .bold()
                .lineLimit(1)
            Text("\(headcount)인")
                .padding(.vertical, 3)
                .padding(.horizontal, 8)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .font(.subheadline)
        .foregroundStyle(.gray)
        .padding(.horizontal, 20)
    }

    private var togglingMemberName: some View {
        HStack {
            Text("팀원 이름 보기")
                .padding(.horizontal, 15)
                .padding(.vertical, 5)
                .foregroundStyle(isNameVisiable ? .gray: .black)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            toggleButton
            Spacer()
        }
        .bold()
        .font(.subheadline)
        .padding(.horizontal, 20)
    }

    private var toggleButton: some View {
        Button {
            isNameVisiable.toggle()
        } label: {
            Text(isNameVisiable ? "off" : "on")
                .foregroundStyle(.green)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                withAnimation(.easeIn(duration: 0.3)) {
                    isAddVisible.toggle()
                }
            } label: {
                Text(isAddVisible ? "완료" : "추가")
                    .foregroundStyle(.green)
            }
        }
    }
}

struct FormationScrollView: View {
    var isNameVisiable: Bool
    var formations: [Formation]
    var isAddVisible: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(formations, id: \.self) { formation in
                    VStack {
                        FormationPreview(isNameVisiable: isNameVisiable,
                                         formation: formation)
                        if isAddVisible {
                            addButton
                        }
                    }
                }
            }.padding(.horizontal, 20)
        }
    }

    var addButton: some View {
        Button {
            // TODO: 자리표 찍기(수정)로 이동
        } label: {
            ZStack {
                Circle()
                    .fill(.green)
                    .frame(width: 40, height: 40)
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .bold()
            }
        }
    }
}

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
                    MemberCircle(isNameVisiable: isNameVisiable,
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

struct MemberCircle: View {
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

struct TimeAndLyric: View {
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

extension Formation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Formation, rhs: Formation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

#Preview {
    WatchingFormationView()
}
