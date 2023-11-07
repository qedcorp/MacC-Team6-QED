// Created by byo.

import UIKit

class ObjectStageViewController: UIViewController {
    private(set) lazy var relativeCoordinateConverter = {
        return RelativeCoordinateConverter(sizeable: view)
    }()

    var isColorAssignable = true
    private var isViewAppeared = false
    private var copiedFormable: Formable?

    var objectViewRadius: CGFloat { 2 }

    var objectViews: [DotObjectView] {
        view.subviews.compactMap { $0 as? DotObjectView }
    }

    convenience init(copiedFormable: Formable?, frame: CGRect) {
        self.init()
        self.copiedFormable = copiedFormable
        self.view.frame = frame
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

    func placeObjectView(position: CGPoint, color: UIColor) {
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
        let colors = (formable as? ColorArrayable)?.colors ?? []
        formable?.relativePositions.enumerated().forEach {
            let position = relativeCoordinateConverter.getAbsoluteValue(of: $0.element)
            let color = (isColorAssignable ? colors[safe: $0.offset]?.map { UIColor(hex: $0) } : nil) ?? .black
            placeObjectView(position: position, color: color)
        }
    }

    final func getRelativePositions() -> [RelativePosition] {
        objectViews.map {
            relativeCoordinateConverter.getRelativeValue(of: $0.center, type: RelativePosition.self)
        }
    }
}
