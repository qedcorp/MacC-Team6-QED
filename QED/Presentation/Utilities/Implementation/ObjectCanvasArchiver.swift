// Created by byo.

import Foundation

class ObjectCanvasArchiver: HistoryControllable {
    weak var objectCanvasViewController: ObjectCanvasViewController?
    private var histories: [any Formable] = []
    private var historyIndex = -1

    func undo() {
        guard isUndoable() else {
            return
        }
        historyIndex -= 1
        copyHistory()
    }

    func redo() {
        guard isRedoable() else {
            return
        }
        historyIndex += 1
        copyHistory()
    }

    func isUndoable() -> Bool {
        historyIndex > 0
    }

    func isRedoable() -> Bool {
        historyIndex >= 0 && historyIndex < histories.count - 1
    }

    func addHistory(_ formable: any Formable) {
        if historyIndex < histories.count - 1 {
            histories = Array(histories.prefix(historyIndex + 1))
        }
        if formable.relativePositions != histories.last?.relativePositions {
            histories.append(formable)
        }
        historyIndex = histories.count - 1
    }

    private func copyHistory() {
        guard let history = histories[safe: historyIndex] else {
            return
        }
        objectCanvasViewController?.copyFormableFromHistory(history)
    }
}
