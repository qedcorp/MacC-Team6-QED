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
    private var rangeToIndex: [ClosedRange<Int>: Int] = [:]

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter(pixelMargin: objectViewRadius)
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    override var objectViewRadius: CGFloat {
        9
    }

    init(movementsMap: MovementsMap, totalCount: Int) {
        self.movementsMap = movementsMap
        self.totalCount = totalCount
        self.pathToPointCalculator = PathToPointCalculator(
            totalPercent: PlayableConstants.transitionLength * PlayableConstants.scale
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mappingIndex()
        settingAppearance()
        setupCenterLines()
        initFormation()
        render()
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

    private func followLine(index: Int) {
        guard let currentRoadIndex = rangeToIndex[index],
              let currentRoadRange = rangeToIndex.getKeyRange(number: index) else { return }

        if beforeRoadIndex != currentRoadIndex {
            for member in memeberRoad {
                let roads = member.value
                for hideIndex in beforeRoadRange {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    roads[hideIndex]?.setting(color: nil, isForce: true)
                    CATransaction.commit()
                }
            }
            beforeRoadIndex = currentRoadIndex
            beforeRoadRange = currentRoadRange
        }
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
        view.backgroundColor = .monoNormal2
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.layer.removeAllAnimations()
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
                    renderPreview(info: member.key, points: previewArray, isFrame: true)
                    renderPreview(info: member.key, points: pathPoints, isFrame: false)

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

    private func mappingIndex() {
        var lastX = 0
        let framIndexCount = Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale)
        let transitionIndexCount = Int(CGFloat(PlayableConstants.transitionLength) * PlayableConstants.scale)

        for index in 0..<totalCount {
            let length = index != totalCount - 1 ? framIndexCount + transitionIndexCount : framIndexCount
            let range = lastX...(lastX + length)
            rangeToIndex[range] = index
            lastX += (length)
        }
    }

    private func renderPreview(info: Member.Info, points: [CGPoint?], isFrame: Bool) {
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
            for point in points {
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

    private func setupCenterLines() {
        let renderer = CenterLinesRenderer(color: .blueLight3)
        renderer.render(in: view)
    }
}

extension ObjectPlayableViewController {

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
