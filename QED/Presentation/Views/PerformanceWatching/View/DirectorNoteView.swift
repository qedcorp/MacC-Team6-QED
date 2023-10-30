//
//  DirectorNoteView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct DirectorNoteView: View {
    private static let fraction = PresentationDetent.fraction(0.15)
    private static let medium = PresentationDetent.medium
    @State private var settingsDetent = fraction

    @StateObject var viewModel: PerformanceWatchingDetailViewModel
    @Binding var isMemoEditMode: Bool
    @FocusState private var isFoused: Bool

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                HStack {
                    Text("디렉터 노트")
                        .bold()
                    Spacer()
                    editButton
                }
                noteContent
                Spacer()
            }
        }
        .padding([.horizontal, .top], 20)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([Self.fraction, Self.medium], selection: $settingsDetent)
        .presentationBackgroundInteraction(.enabled(upThrough: Self.medium))
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var editButton: some View {
        Button {
            isMemoEditMode.toggle()
            if isMemoEditMode {
                isFoused = true
                settingsDetent = Self.fraction
            } else {
                viewModel.saveNote()
                isFoused = false
            }
        } label: {
            if isMemoEditMode {
                Text("완료")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "pencil")
                    .foregroundStyle(.gray)
            }
        }
    }

    @ViewBuilder
    private var noteContent: some View {
        if isMemoEditMode {
            TextEditor(text: $viewModel.currentNote)
                .disableAutocorrection(true)
                .scrollContentBackground(.hidden)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .focused($isFoused, equals: true)
                .frame(height: 100)
                .tint(.green)
        } else {
            Text(viewModel.currentNote == "" ? "메모를 입력하세요" : viewModel.currentNote)
                .foregroundStyle(viewModel.currentNote == "" ? .gray : .black)
        }
    }
}
