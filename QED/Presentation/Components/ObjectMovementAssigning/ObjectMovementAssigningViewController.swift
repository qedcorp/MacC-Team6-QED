// Created by byo.

import Combine
import UIKit

class ObjectMovementAssigningViewController: ObjectStageViewController {
    var onChange: ((MovementMap) -> Void)?

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter()
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var draggingHandler = DraggingHandler()

    private var movementMap: MovementMap = [:]
    private var selectedMemberInfo: Member.Info?
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
                    handleDragging(dragging)
                } else {
                    onChange?(movementMap)
                }
            }
            .store(in: &cancellables)
    }

    private func handleDragging(_ dragging: DraggingModel) {
        guard let memberInfo = selectedMemberInfo else {
            return
        }
        let controlPoint = relativeCoordinateConverter.getRelativeValue(
            of: dragging.currentPosition,
            type: BezierPath.ControlPoint.self
        )
        movementMap[memberInfo]?.controlPoint = controlPoint
        placeBezierPathLayers()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        selectedMemberInfo = movementMap
            .filter { bezierPathConverter.getRect($0.value).contains(position) }
            .randomElement()?
            .key
        draggingHandler.beginDragging(position: position)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        draggingHandler.moveDragging(position: position)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        draggingHandler.endDragging()
    }

    func copy(beforeFormation: Formation, afterFormation: Formation) {
        movementMap = Self.buildLinearMovementMap(
            beforeFormation: beforeFormation,
            afterFormation: afterFormation
        )
        objectViews.forEach { $0.removeFromSuperview() }
        placeObjectViews(formation: beforeFormation)
        placeObjectViews(formation: afterFormation, alpha: 0.3)
        placeBezierPathLayers()
    }

    private func placeObjectViews(formation: Formation, alpha: CGFloat = 1) {
        formation.relativePositions.enumerated().forEach {
            let position = relativeCoordinateConverter.getAbsoluteValue(of: $0.element)
            let color = formation.colors[safe: $0.offset]?.map { UIColor(hex: $0) } ?? .black
            placeObjectView(position: position, color: color.withAlphaComponent(alpha))
        }
    }

    private func placeBezierPathLayers() {
        view.layer.sublayers?
            .compactMap { $0 as? CAShapeLayer }
            .forEach { $0.removeFromSuperlayer() }
        movementMap
            .map { bezierPathConverter.buildCAShapeLayer($0.value) }
            .forEach { view.layer.addSublayer($0) }
    }

    private static func buildLinearMovementMap(
        beforeFormation: Formation,
        afterFormation: Formation
    ) -> MovementMap {
        beforeFormation.members
            .compactMap { beforeMember in
                afterFormation.members.first(where: { $0.info == beforeMember.info })?.info
            }
            .reduce([:]) { map, info in
                guard let beforeMember = beforeFormation.members.first(where: { $0.info == info }),
                      let afterMember = afterFormation.members.first(where: { $0.info == info }) else {
                    return map
                }
                let path = BezierPath(
                    startPosition: beforeMember.relativePosition,
                    endPosition: afterMember.relativePosition,
                    controlPoint: beforeFormation.movementMap?[info]?.controlPoint
                )
                return map.merging([info: path]) { $1 }
            }
    }
}
