// Created by byo.

import UIKit
import Combine

class ObjectCanvasViewController: ObjectStageViewController {
    var maxObjectsCount: Int?
    var onChange: (([RelativePosition]) -> Void)?

    private(set) lazy var historyManager = {
        let manager = ObjectCanvasHistoryManager()
        manager.objectCanvasViewController = self
        return manager
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

    private let draggingHandler = DraggingHandler()
    private var cancellables = Set<AnyCancellable>()

    private var selectedObjectViews: [DotObjectView] = [] {
        didSet {
            objectViews
                .forEach { $0.color = selectedObjectViews.contains($0) ? .green : .black }
        }
    }

    override var objectViewRadius: CGFloat {
        8
    }

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
            } receiveValue: { [weak self] in
                if let dragging = $0 {
                    self?.selectedObjectViews
                        .forEach { $0.applyPositionDiff(dragging.positionDiff) }
                } else {
                    self?.addHistory()
                    self?.didChange()
                }
            }
            .store(in: &cancellables)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getAbsolutePosition(touches: touches) else {
            return
        }
        if let touchedView = touchedViewDetector.detectView(position: position) {
            if let objectView = touchedView as? DotObjectView {
                selectedObjectViews = [objectView]
            }
        } else if selectedObjectViews.isEmpty {
            placeObjectView(position: position)
        }
        draggingHandler.beginDragging(position: position)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let position = touchPositionConverter.getAbsolutePosition(touches: touches) else {
            return
        }
        draggingHandler.moveDragging(position: position)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let position = touchPositionConverter.getAbsolutePosition(touches: touches) else {
            return
        }
        replaceSelectedObjectView()
        if isObjectViewUnselectNeeded(position: position) {
            selectedObjectViews = []
        }
        draggingHandler.endDragging()
    }

    override func placeObjectView(position: CGPoint) {
        guard objectViews.count < maxObjectsCount ?? .max else {
            return
        }
        super.placeObjectView(position: position)
        replaceSelectedObjectView()
    }

    private func replaceSelectedObjectView() {
        selectedObjectViews.forEach {
            let relativePosition = touchPositionConverter.getRelativePosition(absolute: $0.center)
            let absolutePosition = touchPositionConverter.getAbsolutePosition(relative: relativePosition)
            $0.applyPosition(absolutePosition)
        }
    }

    override func copyFormable(_ formable: Formable) {
        super.copyFormable(formable)
        addHistory()
        didChange()
    }

    func copyFormableFromHistory(_ formable: Formable) {
        super.copyFormable(formable)
        didChange()
    }

    func generatePreset() -> Preset {
        defer {
            objectViews.forEach { $0.removeFromSuperview() }
        }
        return Preset(
            headcount: objectViews.count,
            relativePositions: getRelativePositions()
        )
    }

    private func addHistory() {
        let positions = getRelativePositions()
        let history = History(relativePositions: positions)
        historyManager.addHistory(history)
    }

    private func didChange() {
        let positions = getRelativePositions()
        onChange?(positions)
    }

    private func isObjectViewUnselectNeeded(position: CGPoint) -> Bool {
        guard draggingHandler.dragging?.isDragged == false else {
            return false
        }
        let touchedView = touchedViewDetector.detectView(position: position)
        return touchedView == nil
    }

    private func getRelativePositions() -> [RelativePosition] {
        objectViews
            .map { touchPositionConverter.getRelativePosition(absolute: $0.center) }
    }

    private struct History: Formable {
        let relativePositions: [RelativePosition]
    }
}
