//
//  PlayableDanceFormationScene.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import SpriteKit
import SwiftUI

class PlayableDanceFormationScene: SKScene {
    var manager: PlayableDanceFormationManager?

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor(Color(.systemGray6))
        let widthNode = SKShapeNode(rect: CGRect(x: 0,
                                                 y: scene!.frame.height/2,
                                                 width: scene!.frame.width,
                                                 height: 0.5))
        widthNode.strokeColor = .clear
        widthNode.fillColor = UIColor(Color(.systemGreen))
        widthNode.zPosition = -1
        let heightNode = SKShapeNode(rect: CGRect(x: scene!.frame.width/2,
                                                  y: 0,
                                                  width: 0.8,
                                                  height: scene!.frame.height))
        heightNode.strokeColor = .clear
        heightNode.fillColor = UIColor(Color(.systemGreen))
        heightNode.zPosition = -1
        addChild(widthNode)
        addChild(heightNode)
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
