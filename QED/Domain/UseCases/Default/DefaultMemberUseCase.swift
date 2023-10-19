// Created by byo.

import Foundation

struct DefaultMemberUseCase: MemberUseCase {
    func placeMember(relativeX: Int, relativeY: Int) async throws -> Member {
        Member(relativePosition: .init(x: relativeX, y: relativeY))
    }

    func moveMember(_ member: Member, relativeX: Int, relativeY: Int) async throws {
        member.relativePosition = .init(x: relativeX, y: relativeY)
    }

    func applyMemberInfo(_ memberInfo: Member.Info, to member: Member) async throws {
        member.info = memberInfo
    }
}
