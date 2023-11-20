// Created by byo.

import Combine
import UIKit

class ObjectMovementAssigningViewController: ObjectStageViewController {
    struct History: Equatable {
        let movementMap: MovementMap
    }

    var onChange: ((MovementMap) -> Void)?
    weak var objectHistoryArchiver: ObjectHistoryArchiver<History>?
    private let hapticManager = HapticManager.shared

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var bezierPathConverter = {
        let converter = BezierPathConverter(pixelMargin: objectViewRadius)
        converter.relativeCoordinateConverter = relativeCoordinateConverter
        return converter
    }()

    private lazy var draggingHandler = DraggingHandler()

    private var movementMap: MovementMap = [:]
    private var selectedMemberInfo: Member.Info?
    private var cancellables: Set<AnyCancellable> = []

    override func loadView() {
        super.loadView()
        setupViews()
    }

    private func setupViews() {
        GridRenderer().render(in: view)
        CaptionRenderer(text: "무대 앞").render(in: view)
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
                    addHistory()
                    didChange()
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
        hapticManager.hapticImpact(style: .soft)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        selectedMemberInfo = movementMap
            .filter { bezierPathConverter.getTouchableRect($0.value).contains(position) }
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
        // TODO: 깔끔하게 만들자
        let newMovementMap = Self.buildMovementMap(
            beforeFormation: beforeFormation,
            afterFormation: afterFormation
        )
        guard movementMap != newMovementMap else {
            return
        }
        movementMap = newMovementMap
        objectViews.forEach { $0.removeFromSuperview() }
        placeObjectViews(formation: beforeFormation, isBefore: true)
        placeObjectViews(formation: afterFormation)
        placeBezierPathLayers()
        addHistory()
        didChange()
    }

    func copyFromHistory(_ history: History) {
        movementMap = history.movementMap
        placeBezierPathLayers()
        didChange()
        hapticManager.hapticImpact(style: .rigid)
    }

    private func placeObjectViews(formation: Formation, isBefore: Bool = false) {
        formation.relativePositions.enumerated().forEach {
            let position = relativeCoordinateConverter.getAbsoluteValue(of: $0.element)
            if isBefore {
                let viewModel = DotObjectViewModel(
                    radius: objectViewRadius - 1,
                    color: .monoDarker,
                    borderColor: .monoDark,
                    borderWidth: 1
                )
                placeObjectView(position: position, viewModel: viewModel)
            } else {
                let viewModel = DotObjectViewModel(
                    color: formation.colors[safe: $0.offset]?.map { UIColor(hex: $0) } ?? .monoWhite3
                )
                placeObjectView(position: position, viewModel: viewModel)
            }
        }
    }

    private func placeBezierPathLayers() {
        view.layer.sublayers?
            .compactMap { $0 as? BezierPathLayer }
            .forEach { $0.removeFromSuperlayer() }
        movementMap
            .map { bezierPathConverter.buildLayer($0.value, color: UIColor(hex: $0.key.color)) }
            .forEach { view.layer.addSublayer($0) }
    }

    private func addHistory() {
        guard !movementMap.isEmpty else {
            return
        }
        let history = History(movementMap: movementMap)
        objectHistoryArchiver?.addHistory(history)
    }

    private func didChange() {
        onChange?(movementMap)
    }

    private static func buildMovementMap(
        beforeFormation: Formation,
        afterFormation: Formation
    ) -> MovementMap {
        beforeFormation.members
            .compactMap { beforeMember in
                afterFormation.members.first(where: { $0.info?.color == beforeMember.info?.color })?.info
            }
            .reduce([:]) { map, info in
                guard let beforeMember = beforeFormation.members.first(where: { $0.info?.color == info.color }),
                      let afterMember = afterFormation.members.first(where: { $0.info?.color == info.color }) else {
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

extension ObjectMovementAssigningViewController: HistoryControllableDelegate {
    func reflectHistoryFromHistoryControllable<T>(_ history: T) where T: Equatable {
        guard let history = history as? History else {
            return
        }
        copyFromHistory(history)
    }
}
