//
//  WatchingDetailFormationView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct DetailFormationView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel = DetailFormationViewModel()
    @State var isNameVisiable = false
    @State var isBeforeVisible = false
    @State var isPlaying = false
    @State var isMemoEditMode = false
    @State var note = ""
    @State var isFirst: Bool = false

    var body: some View {
        VStack(spacing: 10) {
            DanceFormationView(viewmodel: viewModel)
            detailControlButtons
            PreviewScrollView(viewModel: viewModel,
                              isPlaying: $isPlaying)
            Spacer()
            playButtons
            Spacer()
        }
        .sheet(isPresented: .constant(true)) {
            DirectorNoteView(viewModel: viewModel,
                             isMemoEditMode: $isMemoEditMode,
                             note: $note)
        }
        .onAppear {
            if viewModel.selectedIndex == 0 {
                isFirst = true
            }
        }
        .onChange(of: viewModel.selectedIndex,
                  perform: { selectedIndex in
            if selectedIndex == 0 {
                isFirst = true
                isBeforeVisible = false
            } else {
                isFirst = false
            }
        })
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden()
        .navigationTitle(viewModel.performance.title ?? "")
        .toolbar {
            leftItem
//            rightItem
        }
    }

    private var detailControlButtons: some View {
        HStack {
            HStack {
                Text("이전 동선 미리보기")
                    .foregroundStyle(isFirst || isBeforeVisible ? .gray : .black)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Button {
                        isBeforeVisible.toggle()
                        viewModel.beforeFormationShowingToggle()
                } label: {
                    Text(isBeforeVisible ? "off" : "on")
                        .foregroundStyle(isFirst ? .gray : .green)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .disabled(isFirst ? true : false)
            }
            .bold()
            Spacer()
//            Button {
//                //  TODO: 확대 기능
//            } label: {
//                Image(systemName: "arrow.up.left.and.arrow.down.right")
//                    .padding(5)
//                    .background(Color(.systemGray5))
//                    .foregroundStyle(.gray)
//                    .clipShape(RoundedRectangle(cornerRadius: 5))
//            }
        }
        .font(.subheadline)
        .padding(.bottom, 10)
    }

    private var playButtons: some View {
        HStack(spacing: 20) {
            backwardButton
            playButton
            forwardButton
        }
        .foregroundColor(.green)
        .font(.title2)
    }

    private var backwardButton: some View {
        Button {
            viewModel.backward()
        } label: {
            Image(systemName: "chevron.left")
        }
    }

    private var playButton: some View {
        Button {
            isPlaying.toggle()
            if isPlaying {
                viewModel.play()
            } else {
                viewModel.pause()
            }
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title)
        }
    }

    private var forwardButton: some View {
        Button {
            viewModel.forward()
        } label: {
            Image(systemName: "chevron.right")
        }
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.green)
            }
        }
    }

    private var rightItem: ToolbarItem<(), some View> {
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

struct PreviewScrollView: View {
    @StateObject var viewModel: DetailFormationViewModel
    @Binding var isPlaying: Bool

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack(spacing: 15) {
                    ForEach(Array(zip(viewModel.performance.formations.indices, viewModel.performance.formations)), id: \.0) { (index, formation) in
                        FormationPreview(
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
                .onChange(of: viewModel.selectedIndex, perform: { value in
                    proxy.scrollTo(value, anchor: .center)
                    if viewModel.selectedIndex == viewModel.performance.formations.count - 1 {
                        isPlaying = false
                    }
                })
            }
        }
    }
}

struct PreviewCardView: View {
    @StateObject var viewModel: DetailFormationViewModel
    var index: Int

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
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

#Preview {
    DetailFormationView(viewModel: DetailFormationViewModel())
}
