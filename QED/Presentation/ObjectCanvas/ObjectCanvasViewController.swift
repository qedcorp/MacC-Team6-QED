// Created by byo.

import UIKit
import Combine

class ObjectCanvasViewController: ObjectStageViewController {
    lazy var historyManager = {
        let manager = ObjectCanvasHistoryManager()
        manager.objectCanvasViewController = self
        return manager
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

    private let draggingHandler = DraggingHandler()
    private var cancellables = Set<AnyCancellable>()

    private var selectedObjectView: DotObjectView? {
        didSet {
            objectViews
                .forEach { $0.color = $0 === selectedObjectView ? .green : .black }
        }
    }

    override var objectViewRadius: CGFloat {
        6
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
                    self?.selectedObjectView?.applyPositionDiff(dragging.positionDiff)
                } else {
                    self?.addHistory()
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
                selectedObjectView = objectView
            }
        } else if selectedObjectView == nil {
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
            selectedObjectView = nil
        }
        draggingHandler.endDragging()
    }

    override func placeObjectView(position: CGPoint) {
        super.placeObjectView(position: position)
        replaceSelectedObjectView()
    }

    private func replaceSelectedObjectView() {
        guard let view = selectedObjectView else {
            return
        }
        let relativePosition = touchPositionConverter.getRelativePosition(absolute: view.center)
        let absolutePosition = touchPositionConverter.getAbsolutePosition(relative: relativePosition)
        selectedObjectView?.applyPosition(absolutePosition)
    }

    override func copyPreset(_ preset: Preset) {
        super.copyPreset(preset)
        addHistory()
    }

    func copyPresetWithoutHistory(_ preset: Preset) {
        super.copyPreset(preset)
    }

    func generatePreset() -> Preset {
        defer {
            objectViews.forEach { $0.removeFromSuperview() }
        }
        return buildCurrentPreset()
    }

    private func addHistory() {
        let preset = buildCurrentPreset()
        historyManager.addHistory(preset)
    }

    private func buildCurrentPreset() -> Preset {
        Preset(
            headcount: objectViews.count,
            relativePositions: objectViews
                .map { touchPositionConverter.getRelativePosition(absolute: $0.center) }
        )
    }

    private func isObjectViewUnselectNeeded(position: CGPoint) -> Bool {
        guard draggingHandler.dragging?.isDragged == false else {
            return false
        }
        let touchedView = touchedViewDetector.detectView(position: position)
        return touchedView == nil
    }
}
