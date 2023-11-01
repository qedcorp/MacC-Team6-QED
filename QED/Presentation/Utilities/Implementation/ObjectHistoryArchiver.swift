// Created by byo.

import Foundation

class ObjectHistoryArchiver: HistoryControllable {
    typealias History = any Formable

    weak var canvasController: ObjectCanvasViewController?
    private var histories: [History] = []
    private var historyIndex = -1

    var isUndoable: Bool {
        historyIndex > 0
    }

    var isRedoable: Bool {
        historyIndex >= 0 && historyIndex < histories.count - 1
    }

    func addHistory(_ history: History) {
        guard history.relativePositions != histories[safe: historyIndex]?.relativePositions else {
            return
        }
        if historyIndex < histories.count - 1 {
            histories = Array(histories.prefix(historyIndex + 1))
        }
        histories.append(history)
        historyIndex = histories.count - 1
    }

    func undo() {
        guard isUndoable else {
            return
        }
        historyIndex -= 1
        reflectHistoryToView()
    }

    func redo() {
        guard isRedoable else {
            return
        }
        historyIndex += 1
        reflectHistoryToView()
    }

    private func reflectHistoryToView() {
        guard let history = histories[safe: historyIndex] else {
            return
        }
        canvasController?.copyFormableFromHistory(history)
    }
}
