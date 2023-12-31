// Created by byo.

import UIKit

class ObjectStageViewController: UIViewController {
    private(set) lazy var relativeCoordinateConverter = {
        RelativeCoordinateConverter(sizeable: view)
    }()

    var isColorAssignable = true
    private(set) var isViewAppeared = false
    private var copiedFormable: Formable?

    var objectViewRadius: CGFloat {
        view.frame.height / CGFloat(RelativePosition.maxY)
    }

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
        copyWhenAppeared()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isViewAppeared = false
        copiedFormable = nil
    }

    func placeObjectView(position: CGPoint, viewModel: DotObjectViewModel) {
        let objectView = buildObjectView(viewModel: viewModel)
        objectView.assignPosition(position)
        replaceObjectViewAtRelativePosition(objectView)
        view.addSubview(objectView)
    }

    private func buildObjectView(viewModel: DotObjectViewModel) -> DotObjectView {
        let view = DotObjectView()
        view.radius = viewModel.radius ?? objectViewRadius
        view.color = viewModel.color
        view.borderColor = viewModel.borderColor
        view.borderWidth = viewModel.borderWidth
        view.alpha = viewModel.alpha ?? 1
        return view
    }

    func replaceObjectViewAtRelativePosition(_ view: DotObjectView) {
        let relativePosition = relativeCoordinateConverter.getRelativeValue(
            of: view.center,
            type: RelativePosition.self
        )
        let absolutePosition = relativeCoordinateConverter.getAbsoluteValue(of: relativePosition)
        view.assignPosition(absolutePosition)
    }

    func copyFormable(_ formable: Formable) {
        guard isViewAppeared else {
            copiedFormable = formable
            return
        }
        objectViews.forEach { $0.removeFromSuperview() }
        let colors = (formable as? ColorArrayable)?.colors ?? []
        formable.relativePositions.enumerated().forEach {
            let position = relativeCoordinateConverter.getAbsoluteValue(of: $0.element)
            let viewModel = DotObjectViewModel(
                color: (isColorAssignable ? colors[safe: $0.offset]?.map { UIColor(hex: $0) } : nil) ?? .monoWhite3
            )
            placeObjectView(position: position, viewModel: viewModel)
        }
    }

    func copyWhenAppeared() {
        guard let formable = copiedFormable else {
            return
        }
        copyFormable(formable)
    }

    final func getRelativePositions() -> [RelativePosition] {
        objectViews.map {
            relativeCoordinateConverter.getRelativeValue(of: $0.center, type: RelativePosition.self)
        }
    }
}
