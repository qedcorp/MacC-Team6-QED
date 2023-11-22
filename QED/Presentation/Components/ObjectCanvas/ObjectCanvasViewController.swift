// Created by byo.

import UIKit
import Combine

class ObjectCanvasViewController: ObjectStageViewController {
    struct History: Equatable, Formable {
        let relativePositions: [RelativePosition]
    }

    var maxObjectsCount: Int?
    var onChange: (([CGPoint]) -> Void)?
    weak var objectHistoryArchiver: ObjectHistoryArchiver<History>?
    private let hapticManager = HapticManager.shared

    private lazy var touchPositionConverter = {
        TouchPositionConverter(container: view)
    }()

    private lazy var touchedViewDetector = {
        TouchedViewDetector(container: view, allowedTypes: [DotObjectView.self])
    }()

    private lazy var multiSelectBoxView = {
        let box = MultiSelectBoxView()
        box.layer.zPosition = 100
        view.addSubview(box)
        return box
    }()

    private lazy var draggingHandler = DraggingHandler()

    private var selectedObjectViews: Set<DotObjectView> = [] {
        didSet {
            guard selectedObjectViews != oldValue else {
                return
            }
            objectViews.forEach {
                $0.borderColor = selectedObjectViews.contains($0) ? .blueNormal : nil
                $0.borderWidth = 2.5
            }
            hapticManager.hapticImpact(style: .rigid)
        }
    }

    private var lastPositionTouchedInEmptySpace: CGPoint?
    private var isDraggingForSelectingMultiObjects = false
    private var cancellables: Set<AnyCancellable> = []

    private var canPlaceObject: Bool {
        objectViews.count < maxObjectsCount ?? .max
    }

    private var isNotDragged: Bool {
        draggingHandler.dragging?.isDragged == false
    }

    private var areObjectsSelected: Bool {
        !selectedObjectViews.isEmpty
    }

    override func loadView() {
        super.loadView()
        setupViews()
    }

    private func setupViews() {
        GridRenderer().render(in: view)
        CaptionRenderer(text: "무대 앞").render(in: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeDragging()
    }

    private func subscribeDragging() {
        draggingHandler.$dragging
            .sink { _ in
            } receiveValue: { [unowned self] in
                updateMultiSelectBoxViewFrame(dragging: $0)
                if let dragging = $0 {
                    handleDragging(dragging)
                } else {
                    addHistory()
                    didChange()
                }
            }
            .store(in: &cancellables)
    }

    private func updateMultiSelectBoxViewFrame(dragging: DraggingModel?) {
        multiSelectBoxView.frame = (isDraggingForSelectingMultiObjects ? dragging?.rect : nil) ?? .zero
    }

    private func handleDragging(_ dragging: DraggingModel) {
        if isDraggingForSelectingMultiObjects {
            multiSelectByDragging(dragging)
        } else if areObjectsSelected {
            selectedObjectViews.forEach {
                $0.assignPositionDiff(dragging.positionDiff)
            }
        }
    }

    private func multiSelectByDragging(_ dragging: DraggingModel) {
        guard dragging.rect != .zero else {
            return
        }
        objectViews.forEach {
            if dragging.rect.contains($0.center) {
                selectedObjectViews.insert($0)
            } else {
                selectedObjectViews.remove($0)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        if let objectView = touchedViewDetector.detectView(position: position) as? DotObjectView {
            selectedObjectViews = [objectView]
        } else {
            lastPositionTouchedInEmptySpace = position
        }
        draggingHandler.beginDragging(position: position)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        if lastPositionTouchedInEmptySpace != nil, !areObjectsSelected {
            isDraggingForSelectingMultiObjects = true
        }
        draggingHandler.moveDragging(position: position)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let position = touchPositionConverter.getPosition(touches: touches) else {
            return
        }
        if let position = lastPositionTouchedInEmptySpace, canPlaceObject, isNotDragged {
            let viewModel = DotObjectViewModel(color: .monoWhite3)
            placeObjectView(position: position, viewModel: viewModel)
            hapticManager.hapticImpact(style: .rigid)
        }
        replaceSelectedObjectViews()
        if isObjectViewUnselectNeeded(position: position) {
            selectedObjectViews = []
        }
        lastPositionTouchedInEmptySpace = nil
        isDraggingForSelectingMultiObjects = false
        draggingHandler.endDragging()
    }

    override func placeObjectView(position: CGPoint, viewModel: DotObjectViewModel) {
        super.placeObjectView(position: position, viewModel: viewModel)
        replaceSelectedObjectViews()
    }

    private func replaceSelectedObjectViews() {
        selectedObjectViews.forEach {
            replaceObjectViewAtRelativePosition($0)
        }
    }

    override func copyFormable(_ formable: Formable) {
        super.copyFormable(formable)
        selectedObjectViews = []
        addHistory()
        didChange()
        hapticManager.hapticImpact(style: .rigid)
    }

    func copyFormableFromHistory(_ formable: Formable) {
        super.copyFormable(formable)
        selectedObjectViews = []
        didChange()
    }

    func createPreset() -> Preset {
        defer {
            objectViews.forEach { $0.removeFromSuperview() }
        }
        return getPreset()
    }

    func getPreset() -> Preset {
        let positions = getRelativePositions()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMddHHmmSS"
        return Preset(
            id: dateFormatter.string(from: Date()),
            headcount: objectViews.count,
            relativePositions: positions
        )
    }

    func getPreset(id: String) -> Preset {
        let positions = getRelativePositions()
        return Preset(
            id: id,
            headcount: objectViews.count,
            relativePositions: positions
        )
    }

    private func addHistory() {
        let positions = getRelativePositions()
        let history = History(relativePositions: positions)
        objectHistoryArchiver?.addHistory(history)
    }

    private func didChange() {
        guard isViewAppeared else {
            return
        }
        let positions = objectViews.map { $0.center }
        onChange?(positions)
    }

    private func isObjectViewUnselectNeeded(position: CGPoint) -> Bool {
        guard isNotDragged else {
            return false
        }
        let touchedView = touchedViewDetector.detectView(position: position)
        return touchedView == nil
    }
}

extension ObjectCanvasViewController: HistoryControllableDelegate {
    func reflectHistoryFromHistoryControllable<T>(_ history: T) where T: Equatable {
        guard let formable = history as? Formable else {
            return
        }
        copyFormable(formable)
    }
}
