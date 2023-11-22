// Created by byo.

import Foundation

protocol HistoryControllable {
    var delegate: HistoryControllableDelegate? { get set }
    var isUndoable: Bool { get }
    var isRedoable: Bool { get }

    func undo()
    func redo()
    func reset()
}
