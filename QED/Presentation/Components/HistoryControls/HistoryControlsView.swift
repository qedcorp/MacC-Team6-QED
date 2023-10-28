// Created by byo.

import SwiftUI

struct HistoryControlsView: View {
    let historyControllable: HistoryControllable
    let tag: String

    var body: some View {
        HStack {
            Button("Undo") {
                historyControllable.undo()
            }
            .disabled(!historyControllable.isUndoable())
            // TODO: Redo 고장남
//            Button("Redo") {
//                historyControllable.redo()
//            }
//            .disabled(!historyControllable.isRedoable())
        }
        .tag(tag)
    }
}
