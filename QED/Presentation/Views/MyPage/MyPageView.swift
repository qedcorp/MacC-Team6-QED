//
//  MyPageView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct MyPageView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = MyPageViewModel()
    let termsAndConditions: MyPageList = .termsAndConditions
    let customerSupport: MyPageList = .customerSupport

    @State private var isTermsVisible = false
    @State private var isPersonalInfoVisble = false
    @State private var message: Message?
    @State private var version: String? = "1.0.0"

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    buildProfileView()
                    buildDivider()
                    buildSectionView(section: termsAndConditions)
                    buildDivider()
                    buildSectionView(section: customerSupport)
                }
                buildContectView()
                buildLogoutButton()
                buildVersionInfoView()
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            buildLeftItem()
            buildCenterItem()
        }
        .sheet(isPresented: $isTermsVisible) {
            buildTermsSheetView()
        }
        .sheet(isPresented: $isPersonalInfoVisble) {
            buildPersonalInfoSheetView()
        }
        .onAppear {
            viewModel.getMe()
        }
    }

    private func buildProfileView() -> some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Text("안녕하세요")
                    HStack(spacing: 0) {
                        if let nickname = viewModel.user.nickname {
                            Text("\(nickname) ")
                                .fontWeight(.heavy)
                                .font(.system(size: 25))
                        }
                        Text("디렉터님")
                    }
                }
                Spacer()
            }
            .font(.title3)
            buildEmailRowView()
        }
        .foregroundStyle(Color.monoWhite3)
        .padding(.vertical, 34)
        .padding(.horizontal, 24)
    }

    private func buildDivider() -> some View {
        Rectangle()
            .frame(height: 10)
            .foregroundStyle(Color.monoBlack)
    }

    private func buildEmailRowView() -> some View {
        HStack(spacing: 4) {
            if let email = viewModel.user.email {
                Text(verbatim: email)
            }
            ZStack {
                Circle()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(.yellow)
                Image("kakao")
            }
            Spacer()
            NavigationLink {
                AccountInfoView(viewModel: viewModel)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .frame(height: 34)
        .font(.subheadline)
    }

    private func buildSectionView(section: MyPageList) -> some View {
        VStack(spacing: 0) {
            buildSectionHeaderView(title: section.title)
            ForEach(section.label, id: \.self) {
                buildListRowView(label: $0)
            }
        }
        .padding(.top, 28)
        .padding(.bottom, 18)
    }

    private func buildSectionHeaderView(title: String) -> some View {
        HStack {
            Text(title)
            Spacer()
        }
        .bold()
        .foregroundColor(.white)
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }

    private func buildListRowView(label: MyPageList.Label) -> some View {
        HStack {
            Text(label.rawValue)
                .foregroundStyle(Color.monoWhite2)
            Spacer()
            buildListContentView(label: label)
        }
        .font(.subheadline)
        .padding(.vertical, 14)
        .padding(.horizontal, 36)
    }

    @ViewBuilder
    private func buildListContentView(label: MyPageList.Label) -> some View {
        switch label {
        case .terms: buildChevronButton({
            isTermsVisible = true
        })
        case .personalInfo: buildChevronButton({
            isPersonalInfoVisble = true
        })
        case .announcement: buildChevronButton({})
        case .appReview: buildChevronButton({})
        }
    }

    private func buildTextListItem(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.white)
    }

    private func buildChevronButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
        }
        .alert(with: $message)
    }

    private func buildToggleButton(isOn: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(isOn ? "toggle_on" : "toggle_off")
        }
    }

    private func buildTermsSheetView() -> some View {
        Text("이용약관")
    }

    private func buildPersonalInfoSheetView() -> some View {
        Text("개인정보 처리 방침")
    }

    private func buildContectView() -> some View {
        VStack(spacing: 5) {
            HStack {
                Text("Q.E.D@gmail.com")
                    .tint(Color.blueLight3)
                    .font(.subheadline)
                    .underline()
                Spacer()
                Button {

                } label: {
                    Text("복사")
                        .foregroundStyle(Color.monoWhite3)
                        .font(.caption2)
                        .underline()
                }
            }

            HStack {
                Text("성함과 연락처를 알려주셔야 정확한 답변이 가능합니다")
                    .foregroundStyle(Color.monoNormal2)
                    .font(.caption2)
                Spacer()
            }
        }
        .padding(.top, 14)
        .padding(.bottom, 19)
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
    }

    private func buildLogoutButton() -> some View {
        Button {
            if let alertMessage = viewModel.alertMessage.first {
                message = alertMessage
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.monoNormal1)

                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Gradient.strokeGlass2, lineWidth: 1)

                Text("로그아웃")
                    .foregroundStyle(Color.monoNormal2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .padding(.horizontal, 24)
        }
    }

    private func buildVersionInfoView() -> some View {
        Text("버전정보 \(version ?? "")")
            .foregroundStyle(Color.monoNormal2)
            .font(.subheadline)
            .bold()
            .padding(.top, 19)
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
            Text("나의 프로필")
                .bold()
                .foregroundColor(.white)
        }
    }
}

#Preview {
    MyPageView()
}
