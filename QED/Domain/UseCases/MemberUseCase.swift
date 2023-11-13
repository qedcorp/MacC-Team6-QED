// Created by byo.

import Foundation

protocol MemberUseCase {
    func placeMember(relativeX: Int, relativeY: Int) async throws -> Member
    func moveMember(_ member: Member, relativeX: Int, relativeY: Int) async throws
    func assignMemberInfo(_ memberInfo: Member.Info, to member: Member) async throws
}
