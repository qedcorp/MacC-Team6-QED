// Created by byo.

import UIKit

class ObjectStageViewController: UIViewController {
    private(set) lazy var relativeCoordinateConverter = {
        RelativeCoordinateConverter(sizeable: view)
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

    func placeObjectView(position: CGPoint, color: UIColor = .black) {
        let objectView = DotObjectView()
        objectView.radius = objectViewRadius
        objectView.color = color
        objectView.assignPosition(position)
        replaceObjectViewAtRelativePosition(objectView)
        view.addSubview(objectView)
    }

    func replaceObjectViewAtRelativePosition(_ view: DotObjectView) {
        let relativePosition = relativeCoordinateConverter.getRelativeValue(
            of: view.center,
            type: RelativePosition.self
        )
        let absolutePosition = relativeCoordinateConverter.getAbsoluteValue(of: relativePosition)
        view.assignPosition(absolutePosition)
    }

    func copyFormable(_ formable: Formable?) {
        guard isViewAppeared else {
            copiedFormable = formable
            return
        }
        objectViews.forEach { $0.removeFromSuperview() }
        formable?.relativePositions
            .map { relativeCoordinateConverter.getAbsoluteValue(of: $0) }
            .forEach { placeObjectView(position: $0) }
    }

    final func getRelativePositions() -> [RelativePosition] {
        objectViews.map {
            relativeCoordinateConverter.getRelativeValue(of: $0.center, type: RelativePosition.self)
        }
    }
}
