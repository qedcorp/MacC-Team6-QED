//
//  ObjectPlayableViewController.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import UIKit

import Combine

class ObjectPlayableViewController: ObjectStageViewController {

    var objectPlayableModel: ObjectPlayableModel
    var memberDots: [Member.Info: DotObjectView] = [:]

    init(firstFormation: Formation, objectPlayableModel: ObjectPlayableModel) {
        self.objectPlayableModel = objectPlayableModel
        super.init(nibName: nil, bundle: nil)
        initFormation(formation: firstFormation)
    }
    
    override func loadView() {
        super.loadView()
        setupCenterLines()
    }

    func setNewMemberFormation(index: Int) {
        for memberDot in memberDots {
            var dotObject = memberDot.value
            guard let points = objectPlayableModel.memeberDacnePoints[memberDot.key],
                  let newPoint = points[safe: index] else { return }
            dotObject.assignPosition(newPoint)
        }
    }

    private func placeDotObject(point: CGPoint, color: UIColor) -> DotObjectView {
        let objectView = DotObjectView()
        objectView.radius = objectViewRadius
        objectView.color = color
        objectView.assignPosition(point)
        replaceObjectViewAtRelativePosition(objectView)
        view.addSubview(objectView)

        return objectView
    }

    private func initFormation(formation: Formation) {
        for member in formation.members {
            let point = relativeCoordinateConverter.getAbsoluteValue(of: member.relativePosition)
            if let memberInfo = member.info {
                let memberDot = placeDotObject(point: point, color: UIColor(hex: memberInfo.color))
                memberDots[memberInfo] = memberDot
            }
        }
    }

    private func setupCenterLines() {
        let renderer = CenterLinesRenderer(color: .green)
        renderer.render(in: view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
