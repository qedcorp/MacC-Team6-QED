// Created by byo.

import Combine
import UIKit

class ObjectMovementViewController: ObjectStageViewController {
    var onChange: (([Member.Info: BezierPath]) -> Void)?

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter()
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

    private lazy var draggingHandler = DraggingHandler()

    private var memberInfoBezierPathMap: [Member.Info: BezierPath] = [:]
    private var cancellables: Set<AnyCancellable> = []
    override var objectViewRadius: CGFloat { 9 }

    override func loadView() {
        super.loadView()
        setupCenterLines()
    }

    private func setupCenterLines() {
        let renderer = CenterLinesRenderer(color: .green)
        renderer.render(in: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeDragging()
    }

    private func subscribeDragging() {
        draggingHandler.$dragging
            .sink { _ in
            } receiveValue: { [unowned self] in
                if let dragging = $0 {
                } else {
                    onChange?(memberInfoBezierPathMap)
                }
            }
            .store(in: &cancellables)
    }

    func copy(beforeFormation: Formation, afterFormation: Formation) {
        memberInfoBezierPathMap = Self.buildMemberInfoBezierPathMap(
            beforeFormation: beforeFormation,
            afterFormation: afterFormation
        )
        objectViews.forEach { $0.removeFromSuperview() }
        placeObjectViewsWithColor(formation: beforeFormation, alpha: 0.3)
        placeObjectViewsWithColor(formation: afterFormation)
        renderMovementBezierPaths()
    }

    private func placeObjectViewsWithColor(formation: Formation, alpha: CGFloat = 1) {
        formation.relativePositions.enumerated().forEach {
            let position = relativeCoordinateConverter.getAbsoluteValue(of: $0.element)
            let color = formation.colors[safe: $0.offset]?.map { UIColor(hex: $0) } ?? .black
            placeObjectView(position: position, color: color.withAlphaComponent(alpha))
        }
    }

    private func renderMovementBezierPaths() {
        view.layer.sublayers?
            .compactMap { $0 as? CAShapeLayer }
            .forEach { $0.removeFromSuperlayer() }
        memberInfoBezierPathMap.values
            .map { bezierPathConverter.buildCAShapeLayer($0) }
            .forEach { view.layer.addSublayer($0) }
    }

    private static func buildMemberInfoBezierPathMap(
        beforeFormation: Formation,
        afterFormation: Formation
    ) -> [Member.Info: BezierPath] {
        beforeFormation.members
            .compactMap { $0.info }
            .compactMap { info in
                afterFormation.members.first(where: { $0.info == info })?.info
            }
            .reduce([:]) { map, info in
                guard let beforeMember = beforeFormation.members.first(where: { $0.info == info }),
                      let afterMember = afterFormation.members.first(where: { $0.info == info }) else {
                    return map
                }
                var map = map
                map[info] = BezierPath(
                    startPosition: beforeMember.relativePosition,
                    endPosition: afterMember.relativePosition
                )
                return map
            }
    }
}
