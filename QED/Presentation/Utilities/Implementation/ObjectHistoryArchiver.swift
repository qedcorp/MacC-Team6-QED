// Created by byo.

import Foundation

class ObjectHistoryArchiver<History: Equatable>: HistoryControllable {
    weak var delegate: HistoryControllableDelegate?
    private var histories: [History] = []
    private var historyIndex = -1

    var isUndoable: Bool {
        historyIndex > 0
    }

    var isRedoable: Bool {
        historyIndex >= 0 && historyIndex < histories.count - 1
    }

    func addHistory(_ history: History) {
        guard history != histories[safe: historyIndex] else {
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
        reflectHistory()
    }

    func redo() {
        guard isRedoable else {
            return
        }
        historyIndex += 1
        reflectHistory()
    }

    func reset() {
        histories = []
        historyIndex = -1
    }

    private func reflectHistory() {
        guard let history = histories[safe: historyIndex] else {
            return
        }
        delegate?.reflectHistoryFromHistoryControllable(history)
    }
}
