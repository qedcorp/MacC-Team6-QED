// Created by byo.

import SwiftUI

struct HistoryControlsView: View {
    // TODO: 프로토콜로 쓰고 싶다..
    @ObservedObject private var historyManagable: ObjectCanvasHistoryManager

    init(historyManagable: ObjectCanvasHistoryManager) {
        self.historyManagable = historyManagable
    }

    var body: some View {
        HStack {
            Button("Undo") {
                historyManagable.undo()
            }
            .disabled(!historyManagable.isUndoable())
            Button("Redo") {
                historyManagable.redo()
            }
            .disabled(!historyManagable.isRedoable())
        }
    }
}
