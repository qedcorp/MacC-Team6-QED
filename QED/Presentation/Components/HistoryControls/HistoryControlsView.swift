// Created by byo.

import SwiftUI

struct HistoryControlsView<HistoryController: HistoryControllable>: View {
    let historyController: HistoryController
    let tag: String

    var body: some View {
        HStack {
            Button("Undo") {
                historyController.undo()
            }
            .disabled(!historyController.isUndoable())
            Button("Redo") {
                historyController.redo()
            }
            .disabled(!historyController.isRedoable())
        }
        .tag(tag)
    }
}
