// Created by byo.

import Foundation

@MainActor
class MemberInfoEditingViewModel: ObservableObject {
    @Published private var memberInfos: [MemberInfoModel]
    @Published private(set) var isAlreadySelected = false
    let index: Int
    let colorset: MemberInfoColorset
    let onComplete: (MemberInfoModel) -> Void

    init(
        memberInfos: [MemberInfoModel],
        index: Int,
        colorset: MemberInfoColorset,
        onComplete: @escaping (MemberInfoModel) -> Void
    ) {
        self.memberInfos = memberInfos
        self.index = index
        self.colorset = colorset
        self.onComplete = onComplete
    }

    var memberInfo: MemberInfoModel? {
        memberInfos[safe: index]
    }

    var colors: [String] {
        colorset.colorHexes
    }

    var isEnabledToComplete: Bool {
        memberInfo?.name.isEmpty == false
    }

    func updateName(_ name: String) {
        animate {
            memberInfos[safe: index]?.name = name
        }
    }

    func updateColor(_ color: String) {
        var otherMemberInfos = memberInfos
        otherMemberInfos.remove(at: index)
        animate {
            guard otherMemberInfos.allSatisfy({ $0.color != color }) else {
                isAlreadySelected = true
                return
            }
            memberInfos[safe: index]?.color = color
            isAlreadySelected = false
        }
    }

    func complete() {
        guard let info = memberInfo,
              isEnabledToComplete else {
            return
        }
        onComplete(info)
    }
}
