// Created by byo.

import UIKit
import Combine

class ObjectCanvasViewController: ObjectStageViewController {
    struct History: Equatable, Formable {
        let relativePositions: [RelativePosition]
    }

    var maxObjectsCount: Int?
    var onChange: (([CGPoint]) -> Void)?
    weak var objectHistoryArchiver: ObjectHistoryArchiver<History>?

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

    private lazy var draggingHandler = DraggingHandler()
    private lazy var multiSelectBoxView = MultiSelectBoxView()

    private var selectedObjectViews: Set<DotObjectView> = [] {
        didSet {
            guard selectedObjectViews != oldValue else {
                return
            }
            objectViews.forEach {
                $0.color = selectedObjectViews.contains($0) ? .green : .black
            }
        }
    }

    private var isMultiSelectDragging = false
    private var cancellables: Set<AnyCancellable> = []
    override var objectViewRadius: CGFloat { 9 }

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
            } receiveValue: { [unowned self] in
                updateMultiSelectBoxViewFrame(dragging: $0)
                if let dragging = $0 {
                    handleDragging(dragging)
                } else {
                    addHistory()
                    didChange()
                }
            }
            .store(in: &cancellables)
    }

    private func updateMultiSelectBoxViewFrame(dragging: DraggingModel?) {
        multiSelectBoxView.frame = (isMultiSelectDragging ? dragging?.rect : nil) ?? .zero
    }

    private func handleDragging(_ dragging: DraggingModel) {
        if isMultiSelectDragging {
            multiSelectByDragging(dragging)
        } else if !selectedObjectViews.isEmpty {
            selectedObjectViews.forEach {
                $0.assignPositionDiff(dragging.positionDiff)
            }
        }
    }

    private func multiSelectByDragging(_ dragging: DraggingModel) {
        guard dragging.rect != .zero else {
            return
        }
        objectViews.forEach {
            if dragging.rect.contains($0.center) {
                selectedObjectViews.insert($0)
            } else {
                selectedObjectViews.remove($0)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        if let objectView = touchedViewDetector.detectView(position: position) as? DotObjectView {
            selectedObjectViews = [objectView]
        } else {
            if objectViews.count < maxObjectsCount ?? .max {
                placeObjectView(position: position, color: .black)
            } else if selectedObjectViews.isEmpty {
                isMultiSelectDragging = true
            }
        }
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
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        isMultiSelectDragging = false
        replaceSelectedObjectViews()
        if isObjectViewUnselectNeeded(position: position) {
            selectedObjectViews = []
        }
        draggingHandler.endDragging()
    }

    override func placeObjectView(position: CGPoint, color: UIColor) {
        super.placeObjectView(position: position, color: color)
        replaceSelectedObjectViews()
    }

    private func replaceSelectedObjectViews() {
        selectedObjectViews.forEach {
            replaceObjectViewAtRelativePosition($0)
        }
    }

    override func copyFormable(_ formable: Formable?) {
        super.copyFormable(formable)
        selectedObjectViews = []
        addHistory()
        didChange()
    }

    func copyFormableFromHistory(_ formable: Formable?) {
        super.copyFormable(formable)
        selectedObjectViews = []
        didChange()
    }

    func generatePreset() -> Preset {
        defer {
            objectViews.forEach { $0.removeFromSuperview() }
        }
        let positions = getRelativePositions()
        return Preset(
            headcount: objectViews.count,
            relativePositions: positions
        )
    }

    private func addHistory() {
        let positions = getRelativePositions()
        let history = History(relativePositions: positions)
        objectHistoryArchiver?.addHistory(history)
    }

    private func didChange() {
        let positions = objectViews.map { $0.center }
        onChange?(positions)
    }

    private func isObjectViewUnselectNeeded(position: CGPoint) -> Bool {
        guard draggingHandler.dragging?.isDragged == false else {
            return false
        }
        let touchedView = touchedViewDetector.detectView(position: position)
        return touchedView == nil
    }
}

extension ObjectCanvasViewController: HistoryControllableDelegate {
    func reflectHistoryFromHistoryControllable<T>(_ history: T) where T: Equatable {
        guard let formable = history as? Formable else {
            return
        }
        copyFormable(formable)
    }
}
