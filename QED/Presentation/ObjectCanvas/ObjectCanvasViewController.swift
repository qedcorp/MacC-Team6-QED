// Created by byo.

import UIKit

class ObjectCanvasViewController: UIViewController {
    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(
            container: view,
            allowedTypes: [ObjectView.self],
            touchPositionConverter: touchPositionConverter
        )
    }()

    private var currentObject: ObjectView?

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        if let view = touchedViewDetector.detectView(touch: touch) {
            if let object = view as? ObjectView {
                currentObject = object
            }
        } else {
            placeObject(touch: touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else {
            return
        }
        moveObject(touch: touch)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        currentObject = nil
    }

    private func placeObject(touch: UITouch) {
        let absolutePosition = touchPositionConverter.getAbsolutePosition(touch: touch)
        let object = ObjectView()
        object.frame.origin = absolutePosition
        view.addSubview(object)
        currentObject = object
    }

    private func moveObject(touch: UITouch) {
        let absolutePosition = touchPositionConverter.getAbsolutePosition(touch: touch)
        currentObject?.frame.origin = absolutePosition
    }
}
