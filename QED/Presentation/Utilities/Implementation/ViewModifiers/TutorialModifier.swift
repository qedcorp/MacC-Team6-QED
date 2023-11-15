//
//  TutorialModifier.swift
//  QED
//
//  Created by changgyo seo on 11/16/23.
//

import SwiftUI

struct TutorialModifier: ViewModifier {

    let tutorial: Tutorial
    let condition: Bool

    init(tutorial: Tutorial, isFinish: Bool, condition: () -> Bool) {
        self.tutorial = tutorial
        self.condition = condition()

        if isFinish {
            switch tutorial {
            case .isTouchingToAddMemeber:
                UserDefaultsSetting.isTouchingToAddMemeber = false
            case .isAddPreset:
                UserDefaultsSetting.isAddPreset = false
            case .isDragingGroup:
                UserDefaultsSetting.isDragingGroup = false
            case .isSettingColor:
                UserDefaultsSetting.isSettingColor = false
            }
        }
    }

    func body(content: Content) -> some View {
        if condition && tutorial.isActivate {
            ZStack {
                content
                buildTutorialView()
            }
        } else {
            content
        }
    }

    private func buildTutorialView() -> some View {
        let newX = tutorial.position.x
        let newY = tutorial.position.y
        return TutorialView(words: tutorial.message)
            .position(x: newX, y: newY)
    }
}

extension View {
    func addTutorial(tutorial: Tutorial, isFinish: () -> Bool, condition: () -> Bool) -> some View {
        let temp = isFinish()
        return self
            .modifier(TutorialModifier(tutorial: tutorial,
                                       isFinish: temp,
                                       condition: condition)
            )
    }
}
