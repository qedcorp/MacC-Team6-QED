// Created by byo.

import UIKit

class ObjectSelectionViewController: ObjectStageViewController {
    var colorHex: String?

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getAbsolutePosition(touches: touches) else {
            return
        }
        if let objectView = touchedViewDetector.detectView(position: position) as? DotObjectView {
            updateObjectViewsColor(touchedObjectView: objectView)
        }
    }
    
    private func updateObjectViewsColor(touchedObjectView: DotObjectView) {
        guard let colorHex = colorHex else {
            return
        }
        objectViews
            .forEach {
                let color = UIColor(hex: colorHex)
                if $0 === touchedObjectView {
                    $0.color = color
                } else if $0.color == color {
                    $0.color = .black
                }
            }
    }
}
