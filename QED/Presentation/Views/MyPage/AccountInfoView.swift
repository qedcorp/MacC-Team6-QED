//
//  AccountInfoView.swift
//  QED
//
//  Created by chaekie on 11/14/23.
//

import SwiftUI

struct AccountInfoView: View {
    @ObservedObject var viewModel: MyPageViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var message: Message?

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()

            VStack(spacing: 11) {
                buildSocialAccountView()
                buildWithdrawButton()
                Spacer()
            }
            .font(.subheadline)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            buildLeftItem()
            buildCenterItem()
        }
    }

    private func buildSocialAccountView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.monoNormal1)

            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)

            HStack {
                Text("연동된 소셜계정")
                    .foregroundStyle(Color.monoNormal2)
                Spacer()
                Text("카카오톡")
                    .foregroundStyle(Color.monoWhite3)
                ZStack {
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(.yellow)
                    Image("kakao")
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .padding(.top, 30)
        .padding(.horizontal, 24)
    }

    private func buildWithdrawButton() -> some View {
        HStack {
            Spacer()
            Button {
                if let alertMessage = viewModel.alertMessage.last {
                    message = alertMessage
                }
            } label: {
                Text("탈퇴하기")
                    .foregroundStyle(Color.monoWhite3)
                    .underline()
            }
            .alert(with: $message)
        }
        .padding(.horizontal, 24)
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.blueLight3)
            }
        }
    }

    private func buildCenterItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .principal) {
            Text("계정 정보")
                .bold()
                .foregroundColor(.white)
        }
    }
}

#Preview {
    AccountInfoView(viewModel: MyPageViewModel())
}
