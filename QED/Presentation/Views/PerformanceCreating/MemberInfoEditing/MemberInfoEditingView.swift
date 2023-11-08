// Created by byo.

import SwiftUI

struct MemberInfoEditingView: View {
    @ObservedObject private var viewModel: MemberInfoEditingViewModel

    private let cornerRadius: CGFloat = 12

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
            Color.monoBlack.opacity(0.75)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.complete()
                }
            ZStack(alignment: .bottom) {
                VStack(spacing: 29) {
                    VStack(spacing: 26) {
                        HStack {
                            Text("인물 수정")
                                .foregroundStyle(Color.blueLight3)
                            Spacer()
                        }
                        TextField("", text: .init(
                            get: { viewModel.memberInfo?.name ?? "" },
                            set: { viewModel.updateName($0) }
                        ))
                        .foregroundStyle(Color.monoWhite3)
                        .multilineTextAlignment(.center)
                        .frame(height: 64)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(viewModel.isEnabledToComplete ? Color.blueLight2 : Color.build(hex: .unknown2))
                        )
                    }
                    .font(.title2.weight(.bold))
                    .padding(.horizontal, 30)
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
                                                .strokeBorder(Color.blueLight3, lineWidth: 3)
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
                .padding(.bottom, 35)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.build(hex: .unknown1))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(Gradient.strokeGlass2)
                )
                .padding(.horizontal, 24)
                if viewModel.isAlreadySelected {
                    Text("이미 선택된 컬러입니다")
                        .foregroundStyle(Color.blueLight3)
                        .font(.caption)
                        .frame(height: 16)
                        .padding(.bottom, 11)
                }
            }
        }
    }
}
