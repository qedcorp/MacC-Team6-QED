//
//  ObjectPlayableViewController.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import UIKit

import Combine

class ObjectPlayableViewController: ObjectStageViewController {

    private var movementsMap: MovementsMap
    private var memberDots: [Member.Info: DotObjectView] = [:]
    private var memberPositions: [Member.Info: [CGPoint]] = [:]
    private var pathToPointCalculator: PathToPointCalculator

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter()
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    init(movementsMap: MovementsMap) {
        self.movementsMap = movementsMap
        self.pathToPointCalculator = PathToPointCalculator(totalPercent: CGFloat(Constants.transitionLength))
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        super.loadView()
        setupCenterLines()
        initFormation()
        render()
    }

    func setNewMemberFormation(index: Int) {
        for memberDot in memberDots {
            var dotObject = memberDot.value
            guard let points = memberPositions[memberDot.key],
                  let newPoint = points[safe: index] else { return }
            dotObject.assignPosition(newPoint)
        }
    }

    private func render() {
        for member in movementsMap {
            let absolutePostions = member.value
                .map { bezierPath in
                    let path = bezierPathConverter.buildUIBezierPath(bezierPath).cgPath
                    let framPostion = relativeCoordinateConverter.getAbsoluteValue(of: bezierPath.startPosition)
                    let framPostions = Array(repeating: framPostion, count: Constants.frameLength)
                    return framPostions + pathToPointCalculator.getAllPoints(path)
                }
                .flatMap { $0 }

            memberPositions[member.key] = absolutePostions
        }
    }

    private func initFormation() {
        for member in movementsMap {
            guard let firstPostion = member.value.first?.startPosition else { return }
            let point = relativeCoordinateConverter.getAbsoluteValue(of: firstPostion)
            let memberDot = placeDotObject(point: point, color: UIColor(hex: member.key.color))
            memberDots[member.key] = memberDot
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

    private func setupCenterLines() {
        let renderer = CenterLinesRenderer(color: .green)
        renderer.render(in: view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ObjectPlayableViewController {
    struct Constants {
        static let base = 100
        static let frameLength = 300
        static let transitionLength = 100
    }
}
