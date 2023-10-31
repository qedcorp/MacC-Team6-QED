// Created by byo.

import Foundation

protocol HistoryControllable {
    var isUndoable: Bool { get }
    var isRedoable: Bool { get }

    func undo()
    func redo()
}
