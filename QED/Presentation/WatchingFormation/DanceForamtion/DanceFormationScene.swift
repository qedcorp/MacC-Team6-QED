//
//  DanceFormationScene.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import SpriteKit
import SwiftUI

class DanceFormationScene: SKScene {

    var manager: DanceFormationManager?

    override func didMove(to view: SKView) {
        self.backgroundColor = .lightGray
    }

}

extension Member: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }

    static func == (lhs: Member, rhs: Member) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension SKShapeNode {

    func setPostion(center: CGPoint) {
        let newPosition = CGPoint(x: center.x + (frame.width / 2), y: center.y + (frame.height / 2))
        self.position = newPosition
    }

    func relativePostion(center: CGPoint) -> CGPoint {
        let newPosition = CGPoint(x: center.x + (frame.width / 2), y: center.y + (frame.height / 2))

        return newPosition
    }
}
