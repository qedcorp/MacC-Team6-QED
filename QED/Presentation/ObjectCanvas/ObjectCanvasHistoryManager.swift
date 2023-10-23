// Created by byo.

import Foundation

@MainActor
class ObjectCanvasHistoryManager: ObservableObject, HistoryManagable {
    weak var objectCanvasViewController: ObjectCanvasViewController?
    @Published private var histories: [any Formable] = []
    @Published private var historyIndex = -1

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
        if histories.last?.relativePositions != formable.relativePositions {
            histories.append(formable)
        }
        historyIndex = histories.count - 1
    }

    private func copyHistory() {
        guard (0 ..< histories.count).contains(historyIndex) else {
            return
        }
        objectCanvasViewController?.copyFormableFromHistory(histories[historyIndex])
    }
}
