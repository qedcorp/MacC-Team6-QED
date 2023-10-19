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

    private let draggingHandler = DraggingHandler()
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
            .compactMap { $0 }
            .sink { _ in
            } receiveValue: { [weak self] in
                self?.selectedObjectView?.applyPositionDiff($0.positionDiff)
            }
            .store(in: &cancellables)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getAbsolutePosition(touches: touches) else {
            return
        }
        if let touchedView = touchedViewDetector.detectView(position: position) {
            if let objectView = touchedView as? ObjectView {
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

    private func placeObjectView(position: CGPoint) {
        let objectView = ObjectView()
        objectView.applyPosition(position)
        replaceSelectedObjectView()
        view.addSubview(objectView)
    }

    private func replaceSelectedObjectView() {
        guard let view = selectedObjectView else {
            return
        }
        let relativePosition = touchPositionConverter.getRelativePosition(absolute: view.frame.origin)
        let absolutePosition = touchPositionConverter.getAbsolutePosition(relative: relativePosition)
        selectedObjectView?.applyPosition(absolutePosition)
    }

    func generatePreset() -> Preset {
        let preset = Preset(
            headcount: objectViews.count,
            relativePositions: objectViews
                .map { touchPositionConverter.getRelativePosition(absolute: $0.frame.origin) }
        )
        objectViews.forEach { $0.removeFromSuperview() }
        return preset
    }

    func copyPreset(_ preset: Preset) {
        objectViews.forEach { $0.removeFromSuperview() }
        preset.relativePositions
            .map {
                let view = ObjectView()
                view.frame.origin = touchPositionConverter.getAbsolutePosition(relative: $0)
                return view
            }
            .forEach { view.addSubview($0) }
    }

    private func isObjectViewUnselectNeeded(position: CGPoint) -> Bool {
        guard draggingHandler.dragging?.isDragged == false else {
            return false
        }
        let touchedView = touchedViewDetector.detectView(position: position)
        return touchedView == nil
    }
}
