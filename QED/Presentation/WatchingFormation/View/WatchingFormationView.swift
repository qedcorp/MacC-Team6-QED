//
//  WatchingFormationView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct WatchingFormationView: View {
    var performance: Performance
    @Environment(\.dismiss) private var dismiss
    @State var isNameVisiable = false
    @State var isAddVisible = false

    var body: some View {
        VStack(spacing: 15) {
            titleAndHeadcount
            togglingMemberName
            FormationScrollView(isNameVisiable: isNameVisiable,
                                performance: performance,
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
            if let title = performance.title {
                Text("\(title)")
                    .bold()
                    .lineLimit(1)
            }
            Text("\(performance.headcount)인")
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
            withAnimation(.bouncy(duration: 0.15)) {
                isNameVisiable.toggle()
            }
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
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
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
    var performance: Performance
    var isAddVisible: Bool

    var body: some View {
        ScrollView {
                VStack(spacing: 30) {
                    ForEach(Array(zip(performance.formations.indices, performance.formations)), id: \.1) { index, formation in
                        VStack {
                            NavigationLink(destination: DetailFormationView(viewModel: DetailFormationViewModel(performance: performance))) {
                                FormationPreview(
                                    formation: formation,
                                    index: index,
                                    isNameVisiable: isNameVisiable
                                )
                                .frame(height: 250)
                            }
                            if isAddVisible {
                                addButton
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
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

extension Formation: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Formation, rhs: Formation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
