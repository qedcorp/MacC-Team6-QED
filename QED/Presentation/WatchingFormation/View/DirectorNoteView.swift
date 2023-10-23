//
//  DirectorNoteView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct DirectorNoteView: View {
    @StateObject var viewModel: DetailFormationViewModel
    @Binding var note: String
    @Binding var isMemoEditMode: Bool
    @State private var settingsDetent = PresentationDetent.fraction(0.15)
    @FocusState private var isFoused: Bool?

    var isFocused: Bool
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("디렉터 노트")
                    .bold()
                Spacer()
                Button {
                    if isMemoEditMode {
                        viewModel.memo = note
                       settingsDetent = PresentationDetent.fraction(0.15)
                            isFoused = false
                    } else {
                        settingsDetent = PresentationDetent.medium
                        isFoused = true
                    }
                    isMemoEditMode.toggle()
                } label: {
                    if isMemoEditMode {
                        Text("완료")
                            .foregroundStyle(.gray)
                    } else {
                        Image(systemName: "pencil")
                            .foregroundStyle(.gray)
                    }
                }
            }
            if isMemoEditMode {
                TextEditor(text: $note)
                    .disableAutocorrection(true)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .focused($isFoused, equals: true)

            } else {
                Text(note == "" ?
                     "메모를 입력하세요" :
                        note)
                .foregroundStyle(note == "" ?
                    .gray :
                        .black)
            }
            Spacer()
        }
        .padding([.horizontal, .top], 20)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled)
        .presentationDetents([.fraction(0.15), .medium], selection: $settingsDetent)
        .ignoresSafeArea()
    }
}

 #Preview {
    DirectorNoteView(viewModel: DetailFormationViewModel(),
                     note: .constant("메모메모"),
                     isMemoEditMode: .constant(true),
                     isFocused: false)
 }
