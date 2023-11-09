// swiftlint:disable all
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
    private var isShowingPreview: Bool = true
    private var memeberRoad: [Member.Info: [ForamationPreview?]] = [:]
    private var memberDots: [Member.Info: DotObjectView] = [:]
    private var memberPositions: [Member.Info: [CGPoint]] = [:]
    private var pathToPointCalculator: PathToPointCalculator
   
    private var beforeRoadRange: ClosedRange = 0...0
    private var beforeRoadIndex: Int = -1
    private var beforeIndex: Int = 0
    private var rangeToIndex: [ClosedRange<Int>: Int] = [:]
    private var currentRenderingIndex = -1
    
    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter()
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()
    
    override var objectViewRadius: CGFloat {
        9
    }
    
    init(movementsMap: MovementsMap, totalCount: Int) {
        self.movementsMap = movementsMap
        self.totalCount = totalCount
        self.pathToPointCalculator = PathToPointCalculator(totalPercent: PlayableConstants.transitionLength * PlayableConstants.scale)
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
    
    
    func setNewMemberFormation(offset: CGFloat) {
        let index = Int(round(offset * PlayableConstants.scale))
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
                var roads = member.value
                for hideIndex in beforeRoadRange {
                    roads[hideIndex]?.toggle(isShowing: false)
                }
                for showingIndex in currentRoadRange {
                    roads[showingIndex]?.toggle(isShowing: isShowingPreview)
                }
            }
        }
        
        for member in memeberRoad {
            var roads = member.value
            
            for tempindex in currentRoadRange {
                if tempindex > index {
                    roads[tempindex]?.setting(color: UIColor(hex: roads[tempindex]?.value ?? "000000"))
                }
                else {
                    roads[tempindex]?.setting(color: nil)
                }
            }
        }
        beforeIndex = index
        beforeRoadIndex = currentRoadIndex
        beforeRoadRange = currentRoadRange
    }

    private func settingAppearance() {
        view.backgroundColor = .monoNormal2
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
                    let nilArray = Array(
                        repeating: CGPoint(x: -1, y: -1),
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
            
            let nilArray = Array(
                repeating: CGPoint(x: -1, y: -1),
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
                if let dotView = previewView as? PreviewDotView {
                    view.addSubview(dotView)
                }
                if let lineView = previewView as? PreviewLineView {
                    view.addSubview(lineView)
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
    
    private func renderPreview(info: Member.Info, points: [CGPoint], isFrame: Bool) {
        var answer: [ForamationPreview?] = []
        if isFrame {
            for point in points {
                if point != CGPoint(x: -1, y: -1) {
                    let dotView = PreviewDotView(value: UIColor.monoNormal2.getHexString()!)
                    dotView.radius = 8
                    dotView.frame.origin = CGPoint(x: point.x - dotView.frame.width / 2, y: point.y - dotView.frame.height / 2)
                    answer.append(dotView)
                }
                else {
                    answer.append(nil)
                }
            }
        }
        else {
            for point in points {
                if point != CGPoint(x: -1, y: -1) {
                    let transitionView = PreviewLineView(value: info.color)
                    transitionView.assignPosition(point)
                    transitionView.radius = 1
                    answer.append(transitionView)
                }
                else {
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
    
    final class PreviewDotView: DotObjectView, ForamationPreview {
        
        var isVisit: Bool = false
        var status: ObjectPlayableViewController.Status = .notPassButNotShowing
        var isPast: Bool = false
        var value: String {
            didSet {
                backgroundColor = UIColor(hex: value)
            }
        }
        
        
        init(value: String) {
            self.value = value
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setting(color: UIColor? = nil) {
            if let setColor = color {
                backgroundColor = UIColor(hex: value)
            }
            else {
                backgroundColor = UIColor(hex: value)
            }
        }
        
        func toggle(isShowing: Bool = false) {
            if isShowing {
                switch status {
                case .passButNotShowing:
                    backgroundColor = .clear
                    status = .pass
                case .notPassButNotShowing:
                    backgroundColor = UIColor(hex: value)
                    status = .notPass
                case .pass:
                    backgroundColor = UIColor(hex: value)
                    status = .notPass
                case .notPass:
                    backgroundColor = .clear
                    status = .pass
                }
            }
            else {
                switch status {
                case .passButNotShowing:
                    backgroundColor = .clear
                    status = .notPassButNotShowing
                case .notPassButNotShowing:
                    backgroundColor = .clear
                    status = .passButNotShowing
                case .pass:
                    backgroundColor = .clear
                    status = .passButNotShowing
                case .notPass:
                    isVisit = true
                    backgroundColor = .clear
                    status = .notPassButNotShowing
                }
            }
        }
    }
    
    final class PreviewLineView: DotObjectView, ForamationPreview {
        
        var isVisit: Bool = false
        var status: ObjectPlayableViewController.Status = .notPassButNotShowing
        var isPast: Bool = false
        var value: String {
            didSet {
                backgroundColor = UIColor(hex: value)
            }
        }
        
        init(value: String) {
            self.value = value
            super.init()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setting(color: UIColor? = nil) {
            if let setColor = color {
                backgroundColor = setColor
            }
            else {
                backgroundColor = .clear
            }
        }
        
        func toggle(isShowing: Bool = false) {
            if isShowing {
                switch status {
                case .passButNotShowing:
                    backgroundColor = .clear
                    status = .pass
                case .notPassButNotShowing:
                    backgroundColor = UIColor(hex: value)
                    status = .notPass
                case .pass:
                    backgroundColor = UIColor(hex: value)
                    status = .notPass
                case .notPass:
                    isVisit = true
                    backgroundColor = .clear
                    status = .pass
                }
            }
            else {
                switch status {
                case .passButNotShowing:
                    backgroundColor = .clear
                    status = .notPassButNotShowing
                case .notPassButNotShowing:
                    backgroundColor = .clear
                    status = .passButNotShowing
                case .pass:
                    backgroundColor = .clear
                    status = .passButNotShowing
                case .notPass:
                    backgroundColor = .clear
                    status = .notPassButNotShowing
                }
            }
        }
    }
    
    enum Status {
        case passButNotShowing
        case notPassButNotShowing
        case pass
        case notPass
    }
}

protocol ForamationPreview {
    
    var status: ObjectPlayableViewController.Status { get set }
    var value: String { get set }
    func toggle(isShowing: Bool)
    func setting(color: UIColor?)
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.hashValue)
    }
}

//guard let nowRangeIndex = rangeToIndex[index] else { return }
//if currentRangeIndex != nowRangeIndex {
//    showingPreivews = []
//    hidePreivews = []
//    for member in memeberRoad {
//        guard let road = member.value[safe: nowRangeIndex] else { return }
//        if currentRangeIndex > nowRangeIndex  {
//            for preview in road {
//                hidePreivews.append(preview)
//            }
//        }
//        else {
//            for preview in road {
//                showingPreivews.append(preview)
//            }
//        }
//    }
//    for showingPreivew in showingPreivews {
//        showingPreivew.toggle(isShowing: isShowingPreview)
//    }
//    for hidePreivew in hidePreivews {
//        hidePreivew.toggle(isShowing: isShowingPreview)
//    }
//}
//if beforIndex < currentIndex {
//    var checkIndex = beforIndex
//    while checkIndex <= currentIndex {
//        for member in memeberRoad {
//            guard var road = showingPreivews[],
//                  var preivew = road.popLast() else { return }
//            preivew.toggle(isShowing: isShowingPreview)
//            hidePreivews.append(preivew)
//        }
//        checkIndex += 1
//    }
//}
//else {
//    var checkIndex = currentIndex
//    while checkIndex <= beforIndex {
//        for member in memeberRoad {
//            guard var road = member.value[safe: nowRangeIndex],
//                  var preivew = road.popLast() else { return }
//            preivew.toggle(isShowing: isShowingPreview)
//            hidePreivews.append(preivew)
//        }
//        checkIndex += 1
//    }
//}
