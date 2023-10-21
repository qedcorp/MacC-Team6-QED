// Created by byo.

import Foundation

@MainActor
protocol HistoryManagable: AnyObject {
    func undo()
    func redo()
    func isUndoable() -> Bool
    func isRedoable() -> Bool
}
