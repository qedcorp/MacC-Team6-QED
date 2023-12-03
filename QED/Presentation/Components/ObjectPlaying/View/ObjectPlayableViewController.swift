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

    private var movementsMap: MovementsMap
    private var totalCount: Int
    private var isShowingPreview: Bool = false
    private var memeberRoad: [Member.Info: [ForamationPreview?]] = [:]
    private var memberDots: [Member.Info: DotObjectView] = [:]
    private var memberPositions: [Member.Info: [CGPoint]] = [:]
    private var pathToPointCalculator: PathToPointCalculator

    private var offMap: [Range<Int>: FrameInfo] = [:]
    private var currentPlayingFrameType: PlayingFrameType = .formation
    private var beforeIndex: Int = 0
    private var loadingAction: () -> Void = {}

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter(pixelMargin: objectViewRadius)
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    private lazy var arrowBezierPathRenderer = {
        ArrowBezierPathRenderer(bezierPathConverter: bezierPathConverter)
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
        let forceShowing = self.isShowingPreview != isShowingPreview ? true : false
        self.isShowingPreview = isShowingPreview
        for memberDot in memberDots {
            let dotObject = memberDot.value
            guard let points = memberPositions[memberDot.key],
                  let newPoint = points[safe: index] else { return }
            dotObject.assignPosition(newPoint)
        }
        followLine(index: index, forceShowing: forceShowing)
    }

    func showAllDotName(isNameVisiable: Bool) {
        for memberDot in memberDots {
            memberDot.value.name = isNameVisiable ? memberDot.key.name : nil
        }
    }

    private func mappingIndex() {
        var lastX = 0
        let framIndexCount = Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale)
        let transitionIndexCount = Int(CGFloat(PlayableConstants.transitionLength) * PlayableConstants.scale)

        for index in 0..<totalCount {
            let length = index != totalCount - 1 ? framIndexCount + transitionIndexCount: framIndexCount
            let firstPoint = lastX
            let secondPoint = lastX + framIndexCount
            let thirdPoint = lastX + (framIndexCount + transitionIndexCount)
            if index != totalCount - 1 {
                let frameRange = firstPoint..<secondPoint
                let trasitionRange = (secondPoint)..<thirdPoint
                offMap[frameRange] = .formation(index: index)
                offMap[trasitionRange] = .transition(index: index)
                lastX += (length)
            } else {
                let frameRange = firstPoint..<secondPoint
                offMap[frameRange] = .formation(index: index)
                lastX += (length)
            }
        }
    }

    private func getIndexToAllRange(index: Int) -> Range<Int> {
        var startRange = 0..<0
        var endRange = 0..<0
        for element in offMap {
            if element.value.index == index {
                if element.value.id == "FORMATION" {
                    startRange = element.key
                } else {
                    endRange = element.key
                }
            }
        }
        if totalCount - 1 == index {
            return startRange
        }
        let currentRoadRange = startRange.lowerBound..<endRange.upperBound
        return currentRoadRange
    }

    private func followLine(index: Int, forceShowing: Bool = false) {
        guard let currentInfo = offMap[index] else { return }
        switch currentInfo {
        case let .formation(framIndex):
            if currentPlayingFrameType == .transition {
                if framIndex > 0 && isShowingPreview {
                    line(frameInfo: .formation(index: framIndex - 1), linePresentType: .show)
                }
                line(index: index, linePresentType: .clear)
            }
            if !isShowingPreview {
                line(index: index, linePresentType: .clear)
                if framIndex > 0 {
                    line(frameInfo: .formation(index: framIndex - 1), linePresentType: .clear)
                }
            }
            if forceShowing {
                if framIndex > 0 && isShowingPreview {
                    line(frameInfo: .formation(index: framIndex - 1), linePresentType: .show)
                }
            }
            currentPlayingFrameType = .formation
        case let .transition(framIndex):
            if (framIndex > 0 && currentPlayingFrameType == .formation) || !isShowingPreview {
                line(frameInfo: .formation(index: framIndex - 1), linePresentType: .clear)
            }
            if isShowingPreview {
                line(index: index, linePresentType: .action)
            }
            if forceShowing && !isShowingPreview {
                line(index: index, linePresentType: .clear)
            }
            currentPlayingFrameType = .transition
        }
    }

    private func line(index: Int = -1, frameInfo: FrameInfo? = nil, linePresentType: LinePresentType) {
        let optionalInfo = frameInfo == nil ? offMap[index] : frameInfo
        guard let currentInfo = optionalInfo else { return }
        let currentRoadRange = getIndexToAllRange(index: currentInfo.index)
        for member in memeberRoad {
            let roads = member.value
            for checkIndex in currentRoadRange {
                if (checkIndex < index && linePresentType == .action) || linePresentType == .show {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    roads[checkIndex]?.setting(color: UIColor(hex: roads[checkIndex]?.value ?? ""), isForce: false)
                    CATransaction.commit()
                } else if linePresentType == .action {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    roads[checkIndex]?.setting(color: nil, isForce: false)
                    CATransaction.commit()
                } else {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    roads[checkIndex]?.setting(color: nil, isForce: true)
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
            var absolutePostions: [CGPoint]
            absolutePostions = member.value
                .map { bezierPath in
                    let path = arrowBezierPathRenderer.buildArrowLinePath(bezierPath).cgPath
                    let framPostion = relativeCoordinateConverter.getAbsoluteValue(of: bezierPath.startPosition)
                    let nilArray = [CGPoint?](
                        repeating: nil,
                        count: Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale) - 1
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
                count: (Int(round(PlayableConstants.frameLength)) * Int(PlayableConstants.scale))
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
                    dotView.value = UIColor.monoNormal2.getHexString() ?? ""
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
            let arrowView = PreviewArrowView()
            guard let arrowPath = arrowPath else {
                return
            }
            let relativeMargin = bezierPathConverter.getRelativeMargin(arrowPath)
            arrowView.path = arrowBezierPathRenderer.buildArrowHeadPath(
                arrowPath,
                relativeMargin: relativeMargin
            ).cgPath
            let arrowPoint = bezierPathConverter.getEndPoint(arrowPath, relativeMargin: relativeMargin)
            arrowView.value = info.color
            arrowView.fillColor = UIColor.clear.cgColor
            var isNilPath = false
            for index in 0..<newPoints.count {
                if let point = newPoints[index], !isNilPath {
                    if point ~= arrowPoint {
                        isNilPath = true
                        answer.append(nil)
                        continue
                    }
                    let transitionView = PreviewLineView()
                    transitionView.value = info.color
                    transitionView.radius = 1
                    transitionView.assignPosition(point)
                    answer.append(transitionView)
                } else {
                    answer.append(nil)
                }
            }
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
            memberDot.layer.zPosition = 2
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

    enum LinePresentType {
        case show
        case action
        case clear
    }

    enum PlayingFrameType {
        case formation
        case transition
    }

    final class PreviewArrowView: CAShapeLayer, ForamationPreview {

        var radius: CGFloat = 0
        var value: String = ""

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
            zPosition = 1
            borderWidth = 1
            borderColor = UIColor.clear.cgColor
            masksToBounds = true
            self.cornerRadius = radius
            let layerSize = CGSize(width: radius * 2, height: radius * 2)
            let newPoint = CGPoint(x: point.x - layerSize.width / 2, y: point.y - layerSize.height / 2)
            self.frame = CGRect(x: newPoint.x, y: newPoint.y, width: layerSize.width, height: layerSize.height)
        }

        func setting(color: UIColor? = nil, isForce: Bool) {
            if isForce {
                backgroundColor = UIColor.clear.cgColor
                borderColor = UIColor.clear.cgColor
            } else if let setColor = color {
                borderColor = UIColor.monoDark.cgColor
                backgroundColor = UIColor.monoDarker.cgColor
            } else {
                borderColor = UIColor.monoDark.cgColor
                backgroundColor = UIColor.monoDarker.cgColor
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
