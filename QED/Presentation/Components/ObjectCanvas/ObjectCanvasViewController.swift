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

    private lazy var draggingHandler = DraggingHandler()
    private lazy var multiSelectBoxView = MultiSelectBoxView()

    private var cancellables = Set<AnyCancellable>()
    private var isMultiSelectDragging = false

    private var selectedObjectViews: Set<DotObjectView> = [] {
        didSet {
            guard selectedObjectViews != oldValue else {
                return
            }
            objectViews
                .forEach { $0.color = selectedObjectViews.contains($0) ? .green : .black }
        }
    }

    override var objectViewRadius: CGFloat {
        8
    }

    override func loadView() {
        super.loadView()
        view.addSubview(multiSelectBoxView)
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
                self?.updateMultiSelectBoxViewFrame(dragging: $0)
                if let dragging = $0 {
                    self?.handleDragging(dragging)
                } else {
                    self?.addHistory()
                    self?.didChange()
                }
            }
            .store(in: &cancellables)
    }

    private func handleDragging(_ dragging: DraggingModel) {
        if isMultiSelectDragging {
            multiSelectByDragging(dragging)
        } else if !selectedObjectViews.isEmpty {
            selectedObjectViews
                .forEach { $0.applyPositionDiff(dragging.positionDiff) }
        }
    }

    private func multiSelectByDragging(_ dragging: DraggingModel) {
        guard dragging.rect != .zero else {
            return
        }
        objectViews
            .forEach {
                if dragging.rect.contains($0.center) {
                    selectedObjectViews.insert($0)
                } else {
                    selectedObjectViews.remove($0)
                }
            }
    }

    private func updateMultiSelectBoxViewFrame(dragging: DraggingModel?) {
        multiSelectBoxView.frame = (isMultiSelectDragging ? dragging?.rect : nil) ?? .zero
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getAbsolutePosition(touches: touches) else {
            return
        }
        if let objectView = touchedViewDetector.detectView(position: position) as? DotObjectView {
            selectedObjectViews = [objectView]
        } else {
            if objectViews.count < maxObjectsCount ?? .max {
                placeObjectView(position: position)
            } else if selectedObjectViews.isEmpty {
                isMultiSelectDragging = true
            }
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
        isMultiSelectDragging = false
        replaceSelectedObjectViews()
        if isObjectViewUnselectNeeded(position: position) {
            selectedObjectViews = []
        }
        draggingHandler.endDragging()
    }

    override func placeObjectView(position: CGPoint) {
        super.placeObjectView(position: position)
        replaceSelectedObjectViews()
    }

    private func replaceSelectedObjectViews() {
        selectedObjectViews.forEach {
            let relativePosition = touchPositionConverter.getRelativePosition(absolute: $0.center)
            let absolutePosition = touchPositionConverter.getAbsolutePosition(relative: relativePosition)
            $0.applyPosition(absolutePosition)
        }
    }

    override func copyFormable(_ formable: Formable) {
        super.copyFormable(formable)
        selectedObjectViews = []
        addHistory()
        didChange()
    }

    func copyFormableFromHistory(_ formable: Formable) {
        super.copyFormable(formable)
        selectedObjectViews = []
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