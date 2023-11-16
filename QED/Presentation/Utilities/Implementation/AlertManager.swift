//
//  AlertManager.swift
//  QED
//
//  Created by chaekie on 11/9/23.
//

import SwiftUI

enum Message {
    case information(title: String, body: String)
    case confirmation(title: String, body: String, label: String, action: () -> Void)
    case destruction(title: String, body: String, label: String, action: () -> Void)
}

extension Message: Identifiable {
    var id: String { String(reflecting: self) }
}

extension Message {
    func show() -> Alert {
        switch self {

        case let .information(title, body):
            return Alert(
                title: Text(title),
                message: Text(body)
            )

        case let .confirmation(title, body, label, action):
            return Alert(
                title: Text(title),
                message: Text(body),
                primaryButton: .default(Text(label), action: action),
                secondaryButton: .cancel()
            )

        case let .destruction(title, body, label, action):
            return Alert(
                title: Text(title),
                message: Text(body),
                primaryButton: .destructive(Text(label), action: action),
                secondaryButton: .cancel())
        }
    }
}

extension View {
    func alert(with message: Binding<Message?>) -> some View {
        self.alert(item: message) { $0.show() }
    }
}

enum AlertMessage: CaseIterable {
    case logout
    case withdrawal
    case escape
    case delete

    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "탈퇴하기"
        case .escape:
            return "정말로 나가시겠어요?"
        case .delete:
            return "홈으로 나가기"
        }
    }

    var body: String {
        switch self {
        case .logout:
            return "정말 로그아웃 하시겠어요?"
        case .withdrawal:
            return "FODI 탈퇴 시, 모든 내역이\n삭제되며 복구 할 수 없습니다.\n정말 탈퇴 하시겠습니까?"
        case .escape:
            return "입력된 내용은 저장되지 않아요"
        case .delete:
            return "지금까지 작성한 프로젝트 내용이\n모두 삭제됩니다. 홈으로 나가시겠어요?"
        }
    }

    var lebel: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdrawal:
            return "탈퇴"
        case .escape:
            return "나가기"
        case .delete:
            return "네"
        }
    }
}
