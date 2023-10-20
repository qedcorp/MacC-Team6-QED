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
            if historyManagable.isUndoable() {
                Button("Undo") {
                    historyManagable.undo()
                }
            }
            if historyManagable.isRedoable() {
                Button("Redo") {
                    historyManagable.redo()
                }
            }
        }
    }
}
