// Created by byo.

import UIKit

class ObjectStageViewController: UIViewController {
    private(set) lazy var relativePositionConverter = {
        RelativePositionConverter(sizeable: view)
    }()

    private var isViewAppeared: Bool = false
    private var copiedFormable: Formable?

    var objectViewRadius: CGFloat { 2 }

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
        if let preset = copiedFormable {
            copyFormable(preset)
        }
    }

    func placeObjectView(position: CGPoint) {
        let objectView = DotObjectView()
        objectView.radius = objectViewRadius
        objectView.color = .black
        objectView.assignPosition(position)
        replaceObjectViewAtRelativePosition(objectView)
        view.addSubview(objectView)
    }

    func replaceObjectViewAtRelativePosition(_ view: DotObjectView) {
        let relativePosition = relativePositionConverter.getRelativePosition(of: view.center)
        let absolutePosition = relativePositionConverter.getAbsolutePosition(of: relativePosition)
        view.assignPosition(absolutePosition)
    }

    func copyFormable(_ formable: Formable?) {
        guard isViewAppeared else {
            copiedFormable = formable
            return
        }
        objectViews.forEach { $0.removeFromSuperview() }
        formable?.relativePositions
            .map { relativePositionConverter.getAbsolutePosition(of: $0) }
            .forEach { placeObjectView(position: $0) }
    }
}
