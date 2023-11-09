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
    let defaultInfo: MyPageList = .defaultInfo
    let termsAndConditions: MyPageList = .termsAndConditions
    let manageAccount: MyPageList = .manageAccount

    @State private var isTermsVisible = false
    @State private var isPersonalInfoVisble = false
    @State private var message: Message?

    var body: some View {
        ScrollView {
            VStack {
                buildProfileView()
                buildSectionView(section: defaultInfo)
                buildSectionView(section: termsAndConditions)
                buildSectionView(section: manageAccount)
            }
        }
        .background(Color.monoBlack)
        .navigationBarBackButtonHidden()
        .toolbar {
            buildLeftItem()
            buildCenterItem()
        }
        .sheet(isPresented: $isTermsVisible, content: {
            buildTermsSheetView()
        })
        .sheet(isPresented: $isPersonalInfoVisble, content: {
            buildPersonalInfoSheetView()
        })
        .onAppear {
            viewModel.getMe()
        }
    }

    private func buildProfileView() -> some View {
        VStack(spacing: 10) {
            Image("profile")
                .padding(.bottom, 5)

            Text(viewModel.user.nickname ?? "-")
                .fontWeight(.heavy)
                .foregroundStyle(Color.monoWhite3)

                .font(.system(size: 25))
            Text("포디와 함께한지 \(viewModel.signUpPeriod)일")
                .foregroundStyle(Color.monoNormal2)
        }
        .padding(.top, 28)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .background(Color.monoDarker)
    }

    private func buildSectionView(section: MyPageList) -> some View {
        VStack(spacing: 0) {
            buildSectionHeaderView(title: section.title)
            ForEach(section.label, id: \.self) {
                buildListRowView(label: $0)
            }
        }
        .padding(.top, 30)
        .padding(.bottom, 20)
        .background(Color.monoDarker)
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
        .padding(.horizontal, 36)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private func buildListContentView(label: MyPageList.Label) -> some View {
        let user = viewModel.user
        switch label {
        case .name: buildTextListItem(
            user.nickname ?? "-"
        )
        case .email: buildTextListItem(
            user.email ?? "-"
        )
        case .terms: buildChevronButton({
            isTermsVisible = true
        })
        case .personalInfo: buildChevronButton({
            isPersonalInfoVisble = true
        })
        case .logout: buildChevronButton({
            if let alertMessage = viewModel.alertMessage.first {
                message = alertMessage
            }
        })
        case .withdrawal: buildChevronButton({
            if let alertMessage = viewModel.alertMessage.last {
                message = alertMessage
            }
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

    private func buildTermsSheetView() -> some View {
        Text("이용약관")
    }

    private func buildPersonalInfoSheetView() -> some View {
        Text("개인정보 처리 방침")
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
