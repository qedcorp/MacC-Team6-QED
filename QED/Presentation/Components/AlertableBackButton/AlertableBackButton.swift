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
                return "뒤로가기"
            }
        }

        var content: String {
            switch self {
            case .home:
                return "지금까지 작성한 프로젝트 내용이 모두 삭제됩니다. 홈으로 나가시겠어요?"
            case .back:
                return "ㄹㅇㄱ?"
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
            Button("아니오", role: .cancel) {}
            Button("네", role: .destructive) { dismiss() }
        }) {
            Text(alert.content)
        }
    }
}
