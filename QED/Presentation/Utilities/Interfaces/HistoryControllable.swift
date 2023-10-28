// Created by byo.

import Foundation

protocol HistoryControllable: AnyObject {
    func undo()
    func redo()
    func isUndoable() -> Bool
    func isRedoable() -> Bool
}
