//
//  WatchingDetailFormationView.swift
//  QED
//
//  Created by chaekie on 10/23/23.
//

import SwiftUI

struct DetailFormationView: View {
    var performance: Performance
    var formation: Formation
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = DetailFormationViewModel()
    @State var isNameVisiable = false
    @State var isBeforeVisible = false
    @State var isMemoEditMode = false
    @State var isPlaying = false
    @State var note = ""

    var body: some View {
        VStack(spacing: 10) {
            if let selcetedFormation = viewModel.selcetedFormation {
                FormationPreview(
                    performance: performance,
                    formation: selcetedFormation,
                    isNameVisiable: isNameVisiable
                )
                .frame(height: 280)
            }
            detailControlButtons
            PreviewScrollView(viewModel: viewModel,
                              performance: performance)
            Spacer()
            playButtons
            Spacer()
        }
        .onAppear {
            viewModel.getCurrentFormation(formation: formation)
            if let memo = viewModel.memo {
                note = memo
            }
        }
        .sheet(isPresented: .constant(true)) {
            DirectorNoteView(viewModel: viewModel,
                             note: $note,
                             isMemoEditMode: $isMemoEditMode, isFocused: false)
        }
        .padding(.horizontal, 20)
        .navigationBarBackButtonHidden()
        .navigationTitle(performance.title ?? "")
        .toolbar {
            leftItem
            rightItem
        }
    }

    private var detailControlButtons: some View {
        HStack {
            HStack {
                Text("이전 동선 미리보기")
                    .foregroundStyle(isBeforeVisible ? .gray : .black)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Button {
                    isBeforeVisible.toggle()
                } label: {
                    Text(isBeforeVisible ? "off" : "on")
                        .foregroundStyle(.green)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            .bold()
            Spacer()
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
        .font(.subheadline)
        .padding(.bottom, 10)
    }

    private var playButtons: some View {
        HStack(spacing: 20) {
            Button {
                viewModel.backward(performance: performance)
            } label: {
                Image(systemName: "chevron.left")
            }
            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.title)
            }
            Button {
                viewModel.forward(performance: performance)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
        .foregroundColor(.green)
        .font(.title2)
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
                //                TODO: 상세 동선 수정 기능
            } label: {
                Text("상세/수정")
                    .foregroundStyle(.green)
            }
        }
    }
}

struct PreviewScrollView: View {
    var viewModel: DetailFormationViewModel
    var performance: Performance

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(performance.formations, id: \.self) { formation in
                    PreviewCardView(viewModel: viewModel,
                                    formation: formation)
                }
            }
        }
    }
}

struct PreviewCardView: View {
    @StateObject var viewModel: DetailFormationViewModel
    var formation: Formation

    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemGray6))
            .frame(width: 150, height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        viewModel.selcetedFormation == formation ? .green: .clear,
                        lineWidth: 2)
            )
            .onTapGesture {
                withAnimation(.easeIn(duration: 0.1)) {
                    viewModel.selcetedFormation = formation
                }
            }
    }
}

#Preview {
    DetailFormationView(performance: mockPerformance,
                        formation: mockFormations[0])
}
