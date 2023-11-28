// Created by byo.

import SwiftUI

struct AlertableBackButton: View {
    enum AlertType {
        case home
        case back

        var title: String {
            switch self {
            case .home:
                return "홈으로 나가기"
            case .back:
                return "되돌아가기"
            }
        }

        var content: String {
            switch self {
            case .home:
                return "지금까지 작성한 프로젝트 내용이 모두 삭제됩니다. 홈으로 나가시겠어요?"
            case .back:
                return "보기로 되돌아 갈 경우\n수정사항은 반영되지 않습니다.\n정말 되돌아가시겠어요?"
            }
        }
    }

    let alert: AlertType
    let dismiss: DismissAction
    @State private var isAlertPresented = false

    var body: some View {
        Button {
            isAlertPresented = true
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.blueLight3)
                    .fontWeight(.bold)
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .alert(alert.title, isPresented: $isAlertPresented, actions: {
            Button("취소", role: .cancel) {}
            Button("확인", role: .destructive) { dismiss() }
        }) {
            Text(alert.content)
        }
    }
}
