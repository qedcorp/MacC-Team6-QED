//
//  MusicSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct MusicSetupView: View {
    @StateObject var viewModel: PerformanceSettingViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isSearchFromEmptyText = true

    var body: some View {
        VStack {
            buildSearchFieldView()
            Spacer()

            if viewModel.isSearchingMusic {
                ProgressView()
                Spacer()
            } else if isSearchFromEmptyText {
                buildEmptyMusicView()
                Spacer()
            } else {
                buildSearchResultScrollView()
            }
            NavigationLink {
                if viewmodel.canPressNextButton {
                    viewmodel.buildYameNextView(performance: viewmodel.performance!)
                }
            } label: {
                nextbutton
            }
        }
        .onTapGesture {
            isFocused = false
        }
        .simultaneousGesture(
            DragGesture().onChanged({
                if $0.translation.height != 0 {
                    isFocused = false
                }
            }))
        .onChange(of: viewModel.searchText, perform: { _ in
            if viewModel.searchText.isEmpty {
                isSearchFromEmptyText = true
                viewModel.selectedMusic = nil
            }
        })
        .navigationTitle("노래 선택")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            buildLeftItem()
        }
    }

    private func searchMusic() {
        viewModel.search()
        isSearchFromEmptyText = false
        isFocused = false
    }

    private func buildSearchFieldView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray)

            TextField("가수, 노래", text: $viewModel.searchText)
                .tint(.green)
                .focused($isFocused)
                .onSubmit(of: .text) {
                    searchMusic()
                }
                .submitLabel(.search)
            Spacer()

            Button {
                viewModel.searchText = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black)
                    .opacity(viewModel.searchText.isEmpty ? 0 : 0.1)
            }
        }
        .font(.title3)
        .padding(.horizontal)
        .padding(.vertical, 7.5)
        .foregroundStyle(Color.black)
        .background(.black.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private func buildEmptyMusicView() -> some View {
        Text("노래를 검색하세요")
            .font(Font.custom("Apple SD Gothic Neo", size: 30))
            .bold()
            .foregroundColor(Color(red: 0.76, green: 0.76, blue: 0.76))
    }

    private func buildSearchResultScrollView() -> some View {
        ScrollView {
            VStack {
                ForEach(viewModel.searchedMusics) { music in
                    buildCell(music: music)
                }
            }
            .padding(.vertical)
        }
    }

    @ViewBuilder
    private func buildCell(music: Music) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(music.artistName)
                    .font(.caption2)
                Text(music.title)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(
                    viewModel.selectedMusic?.id ?? "-1" == music.id
                    ? .green
                    : .gray.opacity(0.2)
                )
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    viewModel.selectedMusic?.id ?? "-1" == music.id
                    ? .green
                    : .gray, lineWidth: 2
                )
                .foregroundStyle(.gray.opacity(0.1))
        )
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            if music.id == viewModel.selectedMusic?.id {
                viewModel.selectedMusic = nil
            } else {
                viewModel.selectedMusic = music
            }
        }
    }

    private func buildNextButton() -> some View {
        NavigationLink {
            if let performance = viewModel.performance {
                viewModel.buildYameNextView(performance: performance)
            }
        } label: {
            Text("다음")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.selectedMusic == nil
                            ? .black.opacity(0.2)
                            : .black
                )
                .cornerRadius(14)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .disabled(viewModel.selectedMusic == nil)
    }

    private func buildSearchButton() -> some View {
        Button {
            searchMusic()
        } label: {
            Text("검색")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.searchText.isEmpty
                            ? .black.opacity(0.2)
                            : .black
                )
                .cornerRadius(14)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .disabled(viewModel.searchText.isEmpty)
    }

    private func buildLeftItem() -> ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
                    .bold()
            }
        }
    }
}
