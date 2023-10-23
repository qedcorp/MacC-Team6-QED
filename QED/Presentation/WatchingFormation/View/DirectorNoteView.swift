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

    @StateObject var viewModel: DetailFormationViewModel
    @Binding var isMemoEditMode: Bool
    @Binding var note: String
    @State private var settingsDetent = fraction
    @FocusState private var isFoused: Bool?

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("디렉터 노트")
                    .bold()
                Spacer()
                Button {
                    isMemoEditMode.toggle()
                    if isMemoEditMode {
                        viewModel.saveNote()
                        settingsDetent = Self.fraction
                        isFoused = false
                    } else {
                        settingsDetent = Self.medium
                        isFoused = true
                    }
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
                TextEditor(text: $viewModel.currentNote)
                    .disableAutocorrection(true)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .focused($isFoused, equals: true)
                    .frame(height: 50)
                    .tint(.green)

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
        .presentationDetents([Self.fraction, Self.medium], selection: $settingsDetent)
        .ignoresSafeArea()
        .onChange(of: settingsDetent) {
            if $0 == Self.fraction && isMemoEditMode {
                isMemoEditMode = false
            }
        }
    }
}

#Preview {
    DirectorNoteView(viewModel: DetailFormationViewModel(),
                     isMemoEditMode: .constant(false),
                     note: .constant("메모메모"))
}
