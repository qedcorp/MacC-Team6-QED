//
//  MyPageView.swift
//  QED
//
//  Created by chaekie on 10/18/23.
//

import SwiftUI

struct MyPageView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = MyPageViewModel(
        userUseCase: DIContainer.shared.resolver.resolve(DefaultUserUseCase.self),
        authUseCase: DIContainer.shared.resolver.resolve(DefaultAuthUseCase.self)
    )
    @State private var sectionType: MyPageList = .defaultInfo
    let sections: [String] = MyPageList.allCases.map { $0.title }
    let closureArray: [() -> Void] = []
    let date = 1

    var body: some View {
        ScrollView {
            VStack {
                buildProfileView()
                Button("logout") {
                    viewModel.logout()
                }
                ForEach(sections, id: \.self) {
                    buildSectionView(title: $0)
                }
            }
        }
        .background(Color.monoBlack)
        .navigationBarBackButtonHidden()
        .navigationTitle("나의 프로필")
        .toolbar {
            buildLeftItem()
        }
    }

    private func buildProfileView() -> some View {
        VStack(spacing: 10) {
            Image("profile")
                .padding(.bottom, 10)
            Text("이지은")
                .fontWeight(.heavy)
                .foregroundStyle(Color.monoWhite3)
                .font(.system(size: 25))
            Text("포디와 함께한지 \(date)일")
                .foregroundStyle(Color.monoNormal2)
        }
        .padding(.top, 28)
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
        .background(Color.monoDarker)
    }

    @ViewBuilder
    private func buildContentView(title: MyPageList) -> some View {
      switch title {
      case .defaultInfo: buildDefaultInfoView()
      case .termsAndConditions: buildtermsAndConditionsView()
      case .manageAccount: buildmanageAccountView()
      }
    }

    private func buildSectionView(title: String) -> some View {
        VStack(spacing: 0) {
            buildSectionHeaderView(title: title)
//            buildContentView(title: title)
        }
        .padding(.top, 30)
        .padding(.bottom, 20)
        .background(Color.monoDarker)
    }

    private func buildDefaultInfoView() -> some View {
        VStack(spacing: 0) {
            buildSectionRowView(label: "이름", content: "이지은")
            buildSectionRowView(label: "가입상태", content: "abc@gmail.com")
        }
    }
    private func buildActionAndButton(title: String, _ completion: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button("button", action: completion)
        }
    }

    private func buildtermsAndConditionsView() -> some View {
        VStack {
            buildSectionRowView(label: "이용약관", content: "")
            buildSectionRowView(label: "개인정보 처리 방침", content: "")
            buildSectionRowView(label: "마케팅 정보 수신 동의", content: "")
        }
    }

    private func buildmanageAccountView() -> some View {
        VStack {
            buildSectionRowView(label: "로그아웃", content: "")
        }
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

    private func buildSectionRowView(label: String, content: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.monoWhite2)
            Spacer()
            Text(content)
                .foregroundStyle(Color.monoWhite3)
        }
        .font(.subheadline)
        .padding(.horizontal, 36)
        .padding(.vertical, 12)
        .listRowSeparator(.hidden)
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
}

enum MyPageList: String, CaseIterable {

    case defaultInfo
    case termsAndConditions
    case manageAccount

    var id: String { return title }

    var title: String {
        switch self {
        case .defaultInfo: "기본 정보"
        case .termsAndConditions: "약관 및 정책"
        case .manageAccount: "계정 관리"
        }
    }

//    var components: [Component] {
//        switch self {
//        case .defaultInfo:
//            return [
//                .text("이름", getUserName()),
//                .text("가입상태", getUserEmail())
//            ]
//        case .termsAndConditions:
//            return [
//                .showViewButton("이용약관", <#T##AnyView#>)
//            ]
//        case .manageAccount:
//            return [
//                .actionButton("로그아웃", 1)
//            ]
//        }
//    }

    enum Component {
        case text(String, String)
        case showViewButton(String, AnyView)
        case actionButton(String, Int)
    }

    func getUserName() -> String {
        if let name = try? KeyChainManager.shared.read(account: .name) {
            return name
        }
        return ""
    }

    func getUserEmail() -> String {
        if let email = try? KeyChainManager.shared.read(account: .email) {
            return email
        }
        return ""
    }
}

#Preview {
    MyPageView()
}
