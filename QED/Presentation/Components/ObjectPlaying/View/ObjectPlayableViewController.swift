//
//  ObjectPlayableViewController.swift
//  QED
//
//  Created by changgyo seo on 11/2/23.
//

import UIKit

import Combine

class ObjectPlayableViewController: ObjectStageViewController {

    typealias Constants = PlayableConstants
    typealias FrameInfo = ScrollObservableView.FrameInfo

    private var converter: BezierPathConverter {
        let converter =  BezierPathConverter(pixelMargin: 10)
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }

    private var movementsMap: MovementsMap
    private var totalCount: Int
    private var isShowingPreview: Bool = false
    private var memeberRoad: [Member.Info: [ForamationPreview?]] = [:]
    private var memberDots: [Member.Info: DotObjectView] = [:]
    private var memberPositions: [Member.Info: [CGPoint]] = [:]
    private var pathToPointCalculator: PathToPointCalculator

    private var beforeRoadRange: ClosedRange = 0...0
    private var beforeRoadIndex: Int = -1
    private var beforeIndex: Int = 0
    private var offMap: [ClosedRange<Int>: FrameInfo] = [:]
    private var loadingAction: () -> Void = {}
    private var currentIndex: Int = 0 {
        willSet {
            if newValue - 1 >= 0,
               currentIndex != newValue,
               let range = offMap.getKeyRange(number: newValue - 1) {
                for member in memeberRoad {
                    let roads = member.value
                    for index in range {
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(0)
                        roads[index]?.setting(color: UIColor(hex: roads[index]?.value ?? ""), isForce: true)
                        CATransaction.commit()
                    }
                }
            }
        }
    }

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter(pixelMargin: objectViewRadius)
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    override var objectViewRadius: CGFloat {
        9
    }

    init(movementsMap: MovementsMap, totalCount: Int, _ loadingAction: @escaping () -> Void) {
        self.movementsMap = movementsMap
        self.totalCount = totalCount
        self.pathToPointCalculator = PathToPointCalculator(
            totalPercent: PlayableConstants.transitionLength * PlayableConstants.scale
        )
        self.loadingAction = loadingAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mappingIndex()
        settingAppearance()
        initFormation()
        render()
        loadingAction()
    }

    func setNewMemberFormation(offset: CGFloat, isShowingPreview: Bool = false) {
        let index = Int(round(offset * PlayableConstants.scale))
        self.isShowingPreview = isShowingPreview
        for memberDot in memberDots {
            let dotObject = memberDot.value
            guard let points = memberPositions[memberDot.key],
                  let newPoint = points[safe: index] else { return }
            dotObject.assignPosition(newPoint)
        }
        followLine(index: index)
    }

    private func mappingIndex() {
        var lastX = 0
        let framIndexCount = Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale)
        let transitionIndexCount = Int(CGFloat(PlayableConstants.transitionLength) * PlayableConstants.scale)

        for index in 0..<totalCount {
            let length = index != totalCount - 1 ? framIndexCount + transitionIndexCount - 1 : framIndexCount - 1
            let firstPoint = lastX
            let secondPoint = lastX + framIndexCount
            let thirdPoint = lastX + (framIndexCount + transitionIndexCount - 1)
            if index != totalCount - 1 {
                let frameRange = firstPoint...secondPoint
                let trasitionRange = (secondPoint + 1)...thirdPoint
                offMap[frameRange] = .formation(index: index)
                offMap[trasitionRange] = .transition(index: index)
                lastX += (length+1)
            } else {
                let frameRange = firstPoint...secondPoint
                offMap[frameRange] = .formation(index: index)
                lastX += (length+1)
            }
        }
    }

    private func followLine(index: Int) {
        guard let currentRoadInfo = offMap[index],
              let currentRoadRange = offMap.getKeyRange(number: index) else { return }

        switch currentRoadInfo {
        case let .formation(formationIndex):
            showBeforeMovement(formationIndex)
        case let .transition(formationIndex):
            move(index, currentRoadIndex: formationIndex, currentRoadRange: currentRoadRange)
            showBeforeMovement()
        }
    }

    private func showBeforeMovement(_ index: Int = -1) {
        if index - 1 >= 0 {
            guard let currentRoadRange = offMap.getKeyRange(number: index - 1) else { return }

            for member in memeberRoad {
                let roads = member.value
                for checkIndex in currentRoadRange {
                    if isShowingPreview && index != -1 {
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(0)
                        roads[checkIndex]?.setting(color: UIColor(hex: roads[checkIndex]!.value), isForce: false)
                        CATransaction.commit()
                    } else {
                        CATransaction.begin()
                        CATransaction.setAnimationDuration(0)
                        roads[checkIndex]?.setting(color: nil, isForce: !isShowingPreview)
                        CATransaction.commit()
                    }
                }
            }
        }
    }

    private func move(_ index: Int, currentRoadIndex: Int, currentRoadRange: ClosedRange<Int>) {
        for member in memeberRoad {
            let roads = member.value
            for checkIndex in currentRoadRange {
                if checkIndex < index || !isShowingPreview {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    roads[checkIndex]?.setting(color: nil, isForce: !isShowingPreview)
                    CATransaction.commit()
                } else {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    roads[checkIndex]?.setting(color: UIColor(hex: roads[checkIndex]!.value), isForce: false)
                    CATransaction.commit()
                }
            }
        }
    }

    private func settingAppearance() {
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
    }

    private func render() {
        for member in movementsMap {
            var endPoint: CGPoint = .zero
            var absolutePostions: [CGPoint]!
            absolutePostions = member.value
                .map { bezierPath in
                    let path = bezierPathConverter.buildUIBezierPath(bezierPath).cgPath
                    let framPostion = relativeCoordinateConverter.getAbsoluteValue(of: bezierPath.startPosition)
                    let nilArray = [CGPoint?](
                        repeating: nil,
                        count: (Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale)) - 1
                    )
                    let framPostions = Array(
                        repeating: framPostion,
                        count: (Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale))
                    )
                    let previewArray = [framPostion] + nilArray
                    let pathPoints = pathToPointCalculator.getAllPoints(path)
                    renderPreview(info: member.key, points: previewArray, isFrame: true, bezierPath)
                    renderPreview(info: member.key, points: pathPoints, isFrame: false, bezierPath)
                    endPoint = relativeCoordinateConverter.getAbsoluteValue(of: bezierPath.endPosition)
                    return framPostions + pathPoints
                }
                .flatMap { $0 }

            let nilArray = [CGPoint?](
                repeating: nil,
                count: (Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale)) - 1
            )
            let framPostions = Array(
                repeating: endPoint,
                count: (Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale)) - 1
            )
            let previewArray = [endPoint] + nilArray
            absolutePostions += framPostions
            renderPreview(info: member.key, points: previewArray, isFrame: true)
            memberPositions[member.key] = absolutePostions

            guard let roads = memeberRoad[member.key] else { return }
            for previewView in roads {
                if let newLayer = previewView as? CALayer {
                    view.layer.addSublayer(newLayer)
                }
            }
        }
    }

    private func renderPreview(info: Member.Info, points: [CGPoint?], isFrame: Bool, _ arrowPath: BezierPath? = nil) {
        var answer: [ForamationPreview?] = []
        if isFrame {
            for point in points {
                if let point = point {
                    let dotView = PreviewDotView()
                    dotView.value = UIColor.monoNormal2.getHexString()!
                    dotView.radius = 8
                    dotView.assignPosition(point)
                    answer.append(dotView)
                } else {
                    answer.append(nil)
                }
            }
        } else {
            var newPoints = points
            _ = newPoints.popLast()
            for point in newPoints {
                if let point = point {
                    let transitionView = PreviewLineView()
                    transitionView.value = info.color
                    transitionView.radius = 1
                    transitionView.assignPosition(point)
                    answer.append(transitionView)
                } else {
                    answer.append(nil)
                }
            }
            let arrowView = PreviewArrowView()
            arrowView.path = converter.buildArrowHeadPath(
                arrowPath!,
                tMargin: 0
            ).cgPath
            arrowView.value = info.color
            answer.append(arrowView)
        }
        guard let array = memeberRoad[info] else {
            memeberRoad[info] = answer
            return
        }
        memeberRoad[info] = array + answer
    }

    private func initFormation() {
        for member in movementsMap {
            guard let firstPostion = member.value.first?.startPosition else { return }
            let point = relativeCoordinateConverter.getAbsoluteValue(of: firstPostion)
            let memberDot = placeDotObject(point: point, color: UIColor(hex: member.key.color))
            memberDot.layer.zPosition = 1
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
}

extension ObjectPlayableViewController {

    final class PreviewArrowView: CAShapeLayer, ForamationPreview {

        var radius: CGFloat = 0
        var value: String = "" {
            didSet {
                fillColor = UIColor.clear.cgColor
            }
        }

        func assignPosition(_ point: CGPoint) {
            let newPoint = CGPoint(x: point.x - frame.width / 2, y: point.y - frame.height / 2)
            self.frame = CGRect(x: newPoint.x, y: newPoint.y, width: frame.width, height: frame.height)
        }

        func setting(color: UIColor?, isForce: Bool) {
            if let setColor = color {
                fillColor = setColor.cgColor
            } else {
                fillColor = UIColor.clear.cgColor
            }
        }
    }

    final class PreviewDotView: CALayer, ForamationPreview {

        var radius: CGFloat = 9
        var value: String = ""

        func assignPosition(_ point: CGPoint) {
            masksToBounds = true
            self.cornerRadius = radius
            let layerSize = CGSize(width: radius * 2, height: radius * 2)
            let newPoint = CGPoint(x: point.x - layerSize.width / 2, y: point.y - layerSize.height / 2)
            self.frame = CGRect(x: newPoint.x, y: newPoint.y, width: layerSize.width, height: layerSize.height)
        }

        func setting(color: UIColor? = nil, isForce: Bool) {
            if isForce {
                backgroundColor = UIColor.clear.cgColor
            } else if let setColor = color {
                backgroundColor = UIColor(hex: value).cgColor
            } else {
                backgroundColor = UIColor(hex: value).cgColor
            }
        }
    }

    final class PreviewLineView: CALayer, ForamationPreview {

        var radius: CGFloat = 1
        var value: String = ""

        func assignPosition(_ point: CGPoint) {
            masksToBounds = true
            self.cornerRadius = radius
            let layerSize = CGSize(width: radius * 2, height: radius * 2)
            let newPoint = CGPoint(x: point.x - layerSize.width / 2, y: point.y - layerSize.height / 2)
            self.frame = CGRect(x: newPoint.x, y: newPoint.y, width: layerSize.width, height: layerSize.height)
        }

        func setting(color: UIColor? = nil, isForce: Bool) {
            if let setColor = color {
                backgroundColor = setColor.cgColor
            } else {
                backgroundColor = UIColor.clear.cgColor
            }
        }

    }
}

protocol ForamationPreview {

    var radius: CGFloat { get set }
    var value: String { get set }
    func assignPosition(_ point: CGPoint)
    func setting(color: UIColor?, isForce: Bool)
}
