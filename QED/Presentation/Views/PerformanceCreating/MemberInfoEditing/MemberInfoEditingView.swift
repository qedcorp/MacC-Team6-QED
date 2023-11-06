// Created by byo.

import SwiftUI

struct MemberInfoEditingView: View {
    @ObservedObject private var viewModel: MemberInfoEditingViewModel

    init(memberInfos: [MemberInfoModel], index: Int, onComplete: @escaping (MemberInfoModel) -> Void) {
        let colorset = MemberInfoColorset()
        self.viewModel = MemberInfoEditingViewModel(
            memberInfos: memberInfos,
            index: index,
            colorset: colorset,
            onComplete: onComplete
        )
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.complete()
                }
            ZStack(alignment: .bottom) {
                VStack(spacing: 29) {
                    VStack(spacing: 26) {
                        HStack {
                            Text("인물 수정")
                            Spacer()
                        }
                        TextField("", text: .init(
                            get: { viewModel.memberInfo?.name ?? "" },
                            set: { viewModel.updateName($0) }
                        ))
                        .multilineTextAlignment(.center)
                        .frame(height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white)
                                .shadow(radius: 2)
                        )
                    }
                    .font(.title2)
                    .bold()
                    .padding(.horizontal, 18)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(viewModel.colors.enumerated()), id: \.offset) { _, color in
                                Button {
                                    viewModel.updateColor(color)
                                } label: {
                                    Circle()
                                        .fill(Color(hex: color))
                                        .aspectRatio(contentMode: .fit)
                                        .overlay(
                                            color == viewModel.memberInfo?.color ?
                                            Circle()
                                                .strokeBorder(.gray, lineWidth: 3)
                                            : nil
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                    }
                    .frame(height: 40)
                }
                .padding(.top, 26)
                .padding(.bottom, 36)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.white)
                        .shadow(radius: 2)
                )
                .padding(.horizontal, 24)
                if viewModel.isAlreadySelected {
                    Text("이미 선택된 컬러입니다")
                        .font(.caption)
                        .padding(.bottom, 11)
                }
            }
        }
    }
}
