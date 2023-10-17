// Created by byo.

import Foundation

struct DefaultMemberUseCase: MemberUseCase {
    func placeMember(relativeX: Int, relativeY: Int) async throws -> Member {
        Member(
            relativeX: relativeX,
            relativeY: relativeY
        )
    }

    func moveMember(_ member: Member, relativeX: Int, relativeY: Int) async throws {
        member.relativeX = relativeX
        member.relativeY = relativeY
    }

    func applyMemberInfo(_ memberInfo: Member.Info, to member: Member) async throws {
        member.info = memberInfo
    }
}
