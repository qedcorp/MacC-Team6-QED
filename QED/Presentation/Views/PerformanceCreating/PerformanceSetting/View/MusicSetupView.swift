////
////  MusicSettingView.swift
////  QED
////
////  Created by OLING on 10/18/23.
////
//
// import SwiftUI
//
// struct MusicSetupView: View {
//    @ObservedObject private var viewModel: PerformanceSettingViewModel
//    @Environment(\.dismiss) private var dismiss
//    @FocusState var isFocused: Bool
//    @State private var isExpanded = false
//    @State private var isExpanded2 = false
//    @State private var isExpanded3 = false
//    @State private var isSearchFromEmptyText = true
//
//    init(performanceUseCase: PerformanceUseCase) {
//        self.viewModel = PerformanceSettingViewModel(performanceUseCase: performanceUseCase)
//    }
//
//    var body: some View {
//        DisclosureGroup(
//            isExpanded: $isExpanded3,
//            content: {
//                VStack {
//                    buildSearchFieldView()
//                    Spacer()
//
//                    if viewModel.isSearchingMusic {
//                        ProgressView()
//                        Spacer()
//                    } else if isSearchFromEmptyText {
//                        buildEmptyMusicView()
//                        Spacer()
//                    } else {
//                        buildSearchResultScrollView()
//                    }
//                }
//                .onTapGesture {
//                    isFocused = false
//                }
//                .simultaneousGesture(
//                    DragGesture().onChanged({
//                        if $0.translation.height != 0 {
//                            isFocused = false
//                        }
//                    }))
//                .onChange(of: viewModel.musicTitle, perform: { _ in
//                    if viewModel.musicTitle.isEmpty {
//                        isSearchFromEmptyText = true
//                        viewModel.selectedMusic = nil
//                    }
//                })
//            }
//            ,
//            label: {
//                if isExpanded3 {
//                    Text("프로젝트의 노래를 알려주세요")
//                        .foregroundStyle(Color.blueLight3)
//                        .font(.title3)
//                        .bold()
//                        .padding(.horizontal)
//                        .padding(.vertical, 20)
//                } else {
//                    HStack {
//                        Text("노래")
//                            .foregroundStyle(Color.gray)
//                        Spacer()
//
//                        Text("\(viewModel.artist) - \(viewModel.musicTitle)")
//                            .foregroundStyle(Color.gray)
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 20)
//                }
//            })
//        .disclosureGroupBackground()
//    }
//
//    @ViewBuilder
//    private func buildCell(music: Music) -> some View {
//        HStack {
//            AsyncImage(url: music.albumCoverURL) { image in
//                image
//                    .image?.resizable()
//                    .scaledToFit()
//            }
//            VStack(alignment: .leading) {
//                Text(music.artistName)
//                    .font(.caption2)
//                Text(music.title)
//            }
//            Spacer()
//
//            Image(systemName: "checkmark.circle.fill")
//                .foregroundColor(
//                    viewModel.selectedMusic?.id ?? "-1" == music.id
//                    ? .green
//                    : .gray.opacity(0.2)
//                )
//                .font(.title2)
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .stroke(
//                    viewModel.selectedMusic?.id ?? "-1" == music.id
//                    ? .green
//                    : .gray, lineWidth: 2
//                )
//                .foregroundStyle(.gray.opacity(0.1))
//        )
//        .frame(height: 64)
//        .padding(.horizontal)
//        .contentShape(Rectangle())
//        .onTapGesture {
//            if music.id == viewModel.selectedMusic?.id {
//                viewModel.selectedMusic = nil
//            } else {
//                viewModel.selectedMusic = music
//            }
//        }
//    }
//
//    private func buildSearchFieldView() -> some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundStyle(Color.gray)
//
//            TextField("가수, 노래", text: $viewModel.musicTitle)
//                .tint(.green)
//                .focused($isFocused)
//                .onSubmit(of: .text) {
//                    searchMusic()
//                }
//                .submitLabel(.search)
//            Spacer()
//
//            Button {
//                viewModel.musicTitle = ""
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .foregroundColor(.black)
//                    .opacity(viewModel.musicTitle.isEmpty ? 0 : 0.1)
//            }
//        }
//        .font(.title3)
//        .padding(.horizontal)
//        .padding(.vertical, 7.5)
//        .foregroundStyle(Color.black)
//        .background(.black.opacity(0.08))
//        .clipShape(RoundedRectangle(cornerRadius: 50))
//        .padding(.horizontal, 20)
//        .padding(.top, 16)
//    }
//
//    private func buildEmptyMusicView() -> some View {
//        Text("노래를 검색하세요")
//            .foregroundStyle(Color.monoWhite2)
//            .font(.headline)
//            .bold()
//    }
//
//    private func searchMusic() {
//        viewModel.search()
//        isSearchFromEmptyText = false
//        isFocused = false
//    }
//
//    private func buildSearchResultScrollView() -> some View {
//        ScrollView {
//            VStack {
//                ForEach(viewModel.searchedMusics) { music in
//                    buildCell(music: music)
//                }
//            }
//            .padding(.vertical)
//        }
//    }
//
// }
