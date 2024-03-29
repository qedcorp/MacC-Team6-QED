//
//  MyPageView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct MyPageView: View {
    let toastContainerViewModel: ToastContainerViewModel
    @Binding var path: [PresentType]
    @StateObject private var viewModel = MyPageViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var isTermsVisible = false
    @State private var isPersonalInfoVisble = false
    @State private var message: Message?
    private let termsAndConditions: MyPageList = .termsAndConditions
    private let customerSupport: MyPageList = .customerSupport
    private let termsURL = "https://www.notion.so/uimaph/FODI-178c9110f0594f919879a2a84a797600?pvs=4"
    private let personalInfoURL = "https://www.notion.so/uimaph/58256e6eb7a84e8a8fcbe46c3f1806c4?pvs=4"
    private let appStoreURL = "https://apps.apple.com/kr/app/fodi/id6470155832"
    private let qedEmail = "fodi.official.kr@gmail.com"
    private let feedbackURL = "https://forms.gle/1LTQh5baqV2irxq99"

    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
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
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbar {
            buildLeftItem()
            buildCenterItem()
        }
        .task {
            viewModel.getMe()
        }
    }

    private func openURL(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        openURL(url)
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
                    .frame(height: 34)
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
            .foregroundStyle(Color.monoBlack.opacity(0.2))
    }

    private func buildEmailRowView() -> some View {
        HStack(spacing: 4) {
            if let email = viewModel.user.email {
                Text(verbatim: email)
            }
            if let loginProvider = viewModel.loginProvider {
                ZStack {
                    Circle()
                        .frame(width: 15, height: 15)
                        .foregroundStyle(loginProvider == "kakao" ? .KakaoYellow : Color.monoWhite3)
                    Image(loginProvider)
                }
            }
            Spacer()
            Button {
                let dependency = AccountInfoViewDependency(myPageViewModel: viewModel)
                path.append(.accountInfo(dependency))
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
            openURL(termsURL)
        })
        case .personalInfo: buildChevronButton({
            openURL(personalInfoURL)
        })
        case .appReview: buildChevronButton({
            openURL(appStoreURL)
        })
        case .appFeedback: buildChevronButton({
            openURL(feedbackURL)
        })
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

    private func buildContectView() -> some View {
        VStack(spacing: 5) {
            HStack {
                Button {
                    EmailController.shared.sendEmail(qedEmail)
                } label: {
                    Text(verbatim: qedEmail)
                        .tint(Color.blueLight3)
                        .font(.subheadline)
                        .underline()
                }
                Spacer()
                Button {
                    UIPasteboard.general.setValue(qedEmail, forPasteboardType: "public.plain-text")
                    toastContainerViewModel.presentMessage("이메일 주소가 복사되었습니다")
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
        .padding(.top, -4)
        .padding(.bottom, 91)
        .padding(.horizontal, 36)
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
        Text("버전정보 \(UIApplication.appVersion ?? "")")
            .foregroundStyle(Color.monoNormal2)
            .font(.subheadline)
            .fontWeight(.bold)
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
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}
