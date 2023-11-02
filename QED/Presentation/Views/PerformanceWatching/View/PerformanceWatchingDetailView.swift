//
//  WatchingPerformanceWatchingDetailView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct PerformanceWatchingDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: PerformanceWatchingDetailViewModel
    var index: Int
    @State var isNameVisiable = false
    @State var isBeforeVisible = false
    @State var isPlaying = false
    @State var isMemoEditMode = false

    private static let fraction = PresentationDetent.fraction(0.15)
    private static let medium = PresentationDetent.medium
    @State private var settingsDetent = fraction
    @FocusState private var isFoused: Bool

    var body: some View {
        VStack(spacing: 10) {
            PlayableDanceFormationView(viewmodel: viewModel)
            buildDetailControlButtons()
            buildDanceFormationScrollView()
            Spacer()
            buildPlayButtons()
            Spacer()
        }
        .sheet(isPresented: .constant(true)) {
            buildDirectorNoteView()
        }
        .onAppear {
            viewModel.selectedIndex = index
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden()
        .navigationTitle(viewModel.performance.title ?? "")
        .toolbar {
            buildLeftItem()
            //            rightItem()
        }
    }

    private func buildDetailControlButtons() -> some View {
        HStack {
            HStack {
                Text("이전 동선 미리보기")
                    .foregroundStyle(isBeforeVisible ? .gray : .black)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                buildBeforeFormationButton()
                //                buildZoomInButton()
            }
            .bold()
            Spacer()

        }
        .font(.subheadline)
        .padding(.bottom, 10)
    }

    private func buildBeforeFormationButton() -> some View {
        Button {
            isBeforeVisible.toggle()
            viewModel.beforeFormationShowingToggle()
        } label: {
            Text(isBeforeVisible ? "off" : "on")
                .foregroundStyle(isBeforeVisible ? .gray : .green)
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    private func buildZoomInButton() -> some View {
        Button {
            //  TODO: 확대 기능
        } label: {
            Image(systemName: "arrow.up.left.and.arrow.down.right")
                .padding(5)
                .background(Color(.systemGray5))
                .foregroundStyle(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }

    private func buildPlayButtons() -> some View {
        HStack(spacing: 20) {
            buildBackwardButton()
            buildpPlayButton()
            forwardButton()
        }
        .foregroundColor(.green)
        .font(.title2)
    }

    private func buildBackwardButton() -> some View {
        Button {
            viewModel.backward()
        } label: {
            Image(systemName: "chevron.left")
        }
    }

    private func buildpPlayButton() -> some View {
        let formations = viewModel.performance.formations

        return Button {
            isPlaying.toggle()
            if isPlaying {
                if viewModel.selectedIndex == formations.count - 1 {
                    viewModel.selectedIndex = 0
                } else {
                    viewModel.play()
                }
            } else {
                viewModel.pause()
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title)
        }
    }

    private func forwardButton() -> some View {
        Button {
            viewModel.forward()
        } label: {
            Image(systemName: "chevron.right")
        }
    }

    private func buildDanceFormationScrollView() -> some View {
        let formations = viewModel.performance.formations

        return ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 15) {
                    ForEach(Array(zip(formations.indices, formations)), id: \.0) { (index, formation) in
                        DanceFormationView(
                            formation: formation,
                            index: index,
                            hideLine: true
                        )
                        .frame(width: 150, height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(
                                    viewModel.selectedIndex == index ? .green: .clear,
                                    lineWidth: 2)
                        )
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.1)) {
                                viewModel.selectFormation(selectedIndex: index)
                            }
                        }
                    }
                }
                .onChange(of: viewModel.selectedIndex, perform: { index in
                    withAnimation(.easeIn(duration: 0.2)) {
                        proxy.scrollTo(index, anchor: .center)
                    }
                    if viewModel.selectedIndex == formations.count - 1 {
                        isPlaying = false
                    }
                })
            }
        }
    }

    private func buildDirectorNoteView() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                HStack {
                    Text("디렉터 노트")
                        .bold()
                    Spacer()
                    buildEditButton()
                }

                if isMemoEditMode {
                    buildTextEditorNoteView()
                } else {
                    buildTextNoteView()
                }
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

    private func buildEditButton() -> some View {
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

    private func buildTextEditorNoteView() -> some View {
        TextEditor(text: $viewModel.currentNote)
            .disableAutocorrection(true)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .focused($isFoused, equals: true)
            .frame(height: 100)
            .tint(.green)
    }

    private func buildTextNoteView() -> some View {
        Text(viewModel.currentNote == "" ? "메모를 입력하세요" : viewModel.currentNote)
            .foregroundStyle(viewModel.currentNote == "" ? .gray : .black)
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private func buildRightItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                //  TODO: 상세 동선 수정 기능
            } label: {
                Text("동선수정")
                    .foregroundStyle(.green)
            }
        }
    }
}

#Preview {
    PerformanceWatchingDetailView(viewModel: PerformanceWatchingDetailViewModel(
        performance: mockPerformance1
    ), index: 0)
}
