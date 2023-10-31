// Created by byo.

import UIKit

class ObjectSelectionViewController: ObjectStageViewController {
    var colorHex: String?
    var onChange: (([String?]) -> Void)?

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

    override var objectViewRadius: CGFloat { 8 }

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
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        if let objectView = touchedViewDetector.detectView(position: position) as? DotObjectView {
            let colors = getUpdatedColors(touchedObjectView: objectView)
            updateObjectViews(colors: colors)
            onChange?(colors)
        }
    }

    override func copyFormable(_ formable: Formable?) {
        super.copyFormable(formable)
        guard let colors = (formable as? ColorArrayable)?.colors else {
            return
        }
        updateObjectViews(colors: colors)
    }

    private func updateObjectViews(colors: [String?]) {
        objectViews.enumerated().forEach {
            $0.element.color = colors[safe: $0.offset]?.map { .init(hex: $0) } ?? .black
        }
    }

    private func getUpdatedColors(touchedObjectView: DotObjectView) -> [String?] {
        objectViews.map { view -> String? in
            if view === touchedObjectView {
                return colorHex
            } else if view.color?.getHexString() == colorHex {
                return nil
            } else {
                return view.color?.getHexString()
            }
        }
    }
}
