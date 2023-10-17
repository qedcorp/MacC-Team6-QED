// Created by byo.

import Foundation

protocol MemberUseCase {
    func placeMember(_ member: Member, relativeX: Int, relativeY: Int) async throws
    func moveMember(_ member: Member, relativeX: Int, relativeY: Int) async throws
    func applyMemberInfo(_ memberInfo: Member.Info, to member: Member) async throws
}
