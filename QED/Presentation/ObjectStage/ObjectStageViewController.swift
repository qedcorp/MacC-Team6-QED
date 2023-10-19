// Created by byo.

import UIKit

class ObjectStageViewController: UIViewController {
    private(set) lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private var isViewAppeared: Bool = false
    private var copiedPreset: Preset?

    var objectViewRadius: CGFloat {
        2
    }

    var objectViews: [DotObjectView] {
        view.subviews.compactMap { $0 as? DotObjectView }
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppeared = true
        if let preset = copiedPreset {
            copyPreset(preset)
        }
    }

    func placeObjectView(position: CGPoint) {
        let objectView = DotObjectView()
        objectView.radius = objectViewRadius
        objectView.color = .black
        objectView.applyPosition(position)
        view.addSubview(objectView)
    }

    func copyPreset(_ preset: Preset) {
        guard isViewAppeared else {
            copiedPreset = preset
            return
        }
        objectViews.forEach { $0.removeFromSuperview() }
        preset.relativePositions
            .map { touchPositionConverter.getAbsolutePosition(relative: $0) }
            .forEach { placeObjectView(position: $0) }
    }
}
