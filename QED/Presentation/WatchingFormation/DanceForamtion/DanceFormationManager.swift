//
//  DanceFormationManager.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import SpriteKit

import Combine
import SwiftUI

class DanceFormationManager: ObservableObject {

    weak var scene: DanceFormationScene?
    var formation: Formation
    var nodes: [Member: SKShapeNode] = [:]
    var isPlaying: Bool = false
    var shapeSize: CGRect = .zero

    init(scene: DanceFormationScene, formation: Formation) {
        self.scene = scene
        self.formation = formation

        fetchNew(formation: formation)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func relativePostionToSpritePostion(postion: RelativePosition) -> CGPoint {
        CGPoint(x: (scene!.size.width * CGFloat(postion.spriteX) / CGFloat(RelativePosition.maxX)) + (shapeSize.width / 2),
                y: (scene!.size.height * CGFloat(postion.spriteY) / CGFloat(RelativePosition.maxY)) + (shapeSize.height / 2)
        )
    }

    private func dataToPath(data: Data) -> CGPath? {
        guard let path = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIBezierPath.self, from: data) else {
            return nil
        }
        return path.cgPath
    }

    func pasueAction() {
        for node in nodes {
            node.value.removeAllActions()
        }
    }

    func fetchNew(formation: Formation, isPreview: Bool = false) {
        self.formation = formation
        applyPostion(isPreivew: isPreview)
    }

    func playPerformance(transion: FormationTransition, afterFormation: Formation, completion: @escaping () -> Void ) {
        var group: [SKAction] = []
        var isFirst = true
        let completionAction = SKAction.run {
            print("FUCK")
            self.fetchNew(formation: afterFormation)
            completion()
        }

        for element in nodes {
            guard let key = element.key.info,
                  let data = transion.memberMovements[key],
                  let path = dataToPath(data: data) else { return }
            let node = element.value

            let endMember = afterFormation.members.first(where: { $0.info == key })!
            let endPoint = relativePostionToSpritePostion(postion: endMember.relativePosition)
            if isFirst {
                node.run(SKAction.sequence([SKAction.move(to: endPoint, duration: 2), completionAction]))
                isFirst = false
            } else {
                node.run(SKAction.move(to: endPoint, duration: 2))
            }
        }
    }

    func applyPostion(isPreivew: Bool) {
        scene!.removeAllChildren()
        nodes.removeAll()
        for member in formation.members {
            let node = SKShapeNode(circleOfRadius: 10)
            if !isPreivew {
                node.fillColor = UIColor(Color(hex: member.info?.color ?? "#FFFFFF"))
                nodes[member] = node
            } else {
                node.fillColor = UIColor(Color(hex: member.info?.color ?? "#FFFFFF").opacity(0.3))
            }
            shapeSize = node.frame
            node.position = relativePostionToSpritePostion(postion: member.relativePosition)
            node.strokeColor = .clear

            scene!.addChild(node)
        }
    }
}

extension RelativePosition {
    var spriteX: Int {
        x
    }
    var spriteY: Int {
        1000 - y
    }
}
