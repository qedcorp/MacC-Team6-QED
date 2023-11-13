// Created by byo.

import SwiftUI

struct HistoryControlsView: View {
    let historyControllable: HistoryControllable
    let tag: String

    var body: some View {
        HStack(spacing: 8) {
            Button {
                historyControllable.undo()
            } label: {
                Image("back_\(historyControllable.isUndoable ? "on" : "off")")
            }
            .frame(width: 30, height: 24)
            .disabled(!historyControllable.isUndoable)
            Button {
                historyControllable.redo()
            } label: {
                Image("forward_\(historyControllable.isRedoable ? "on" : "off")")
            }
            .frame(width: 30, height: 24)
            .disabled(!historyControllable.isRedoable)
        }
        .tag(tag)
    }
}
