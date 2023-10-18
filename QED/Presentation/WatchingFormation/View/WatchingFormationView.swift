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

    var performance: Int
    var body: some View {
        VStack(spacing: 15) {
            titleAndHeadcount
            togglingMemberName
            FormationScrollView()
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
            isNameVisiable = !isNameVisiable
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

            } label: {
                Text("선택")
                    .foregroundStyle(.green)
            }
        }
    }
}

struct FormationScrollView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(0..<10) { _ in
                    FormationPreview()
                }
            }.padding(.horizontal, 20)
        }
    }
}

struct FormationPreview: View {
    var body: some View {
        VStack(spacing: 0) {
            danceFormation
            TimeAndLyric()
        }
    }

    private var danceFormation: some View {
        ZStack {
            danceFormationBackground
            centerline
            MemberCircle()
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
    var name = "쥬쥬"
    var color: Color = .pink

    var body: some View {
        Text(name)
            .foregroundStyle(.white)
            .font(.caption2)
            .bold()
            .padding(8)
            .background(color)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}

struct TimeAndLyric: View {
    var time = "0:13"
    var lyric = "Pop pop"

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .clipShape(
                    .rect(bottomLeadingRadius: 12,
                          bottomTrailingRadius: 12))
                .frame(height: 30)
            Text("\(time)  \(lyric)")
                .padding(.horizontal)
                .lineLimit(1)
                .foregroundStyle(.white)
                .bold()
        }
    }
}

#Preview {
    WatchingFormationView(performance: 1)
}
