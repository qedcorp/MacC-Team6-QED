// Created by byo.

import UIKit
import Combine

class ObjectCanvasViewController: UIViewController {
    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [ObjectView.self])
    }()

    private lazy var draggingHandler = {
        DraggingHandler(touchPositionConverter: touchPositionConverter)
    }()

    private var cancellables = Set<AnyCancellable>()

    private var selectedObjectView: ObjectView? {
        didSet {
            objectViews.forEach { $0.color = $0 === selectedObjectView ? .red : .black }
        }
    }

    private var objectViews: [ObjectView] {
        view.subviews.compactMap { $0 as? ObjectView }
    }

    override func loadView() {
        super.loadView()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .lightGray
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
                self?.updateSelectedObjectView(dragging: $0)
            }
            .store(in: &cancellables)
    }

    private func updateSelectedObjectView(dragging: Dragging?) {
        guard let dragging = dragging else {
            selectedObjectView?.refreshLastPosition()
            return
        }
        selectedObjectView?.applyPositionDiff(dragging.positionDiff)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        if let touchedView = touchedViewDetector.detectView(touch: touch) {
            switch touchedView {
            case let objectView as ObjectView:
                selectedObjectView = objectView
            default:
                break
            }
        } else if selectedObjectView == nil {
            placeObjectView(touch: touch)
        }
        draggingHandler.beginDragging(touch: touch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        draggingHandler.moveDragging(touch: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        if isObjectViewUnselectNeeded(touch: touch) {
            selectedObjectView = nil
        }
        draggingHandler.endDragging()
    }

    private func placeObjectView(touch: UITouch) {
        let position = touchPositionConverter.getAbsolutePosition(touch: touch)
        let objectView = ObjectView()
        objectView.frame.origin = position
        view.addSubview(objectView)
    }

    private func isObjectViewUnselectNeeded(touch: UITouch) -> Bool {
        guard draggingHandler.dragging?.isDragged == false else {
            return false
        }
        let touchedView = touchedViewDetector.detectView(touch: touch)
        return touchedView == nil
    }
}
