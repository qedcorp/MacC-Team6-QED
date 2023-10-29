// Created by byo.

import Foundation

protocol HistoryControllable {
    func undo()
    func redo()
    func isUndoable() -> Bool
    func isRedoable() -> Bool
}
