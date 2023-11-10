//  swiftlint:disable all
//  PerformanceSettingView.swift
//  QED
//
//  Created by OLING on 11/6/23.
//

import Foundation
import SwiftUI

 

struct PerformanceSettingView: View {

    @ObservedObject private var viewModel: PerformanceSettingViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var isFocused: Bool
    @State private var isSearchFromEmptyText = true
    //    @State private var revealDetails = false

    init(performanceUseCase: PerformanceUseCase) {
        self.viewModel = PerformanceSettingViewModel(performanceUseCase: performanceUseCase)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView {
                    VStack {
                        // 프로젝트 이름
                        TitleSetupView(performanceUseCase: viewModel.performanceUseCase)

                        // 프로젝트 노래
//                        MusicSetupView(performanceUseCase: viewModel.performanceUseCase)
                        DisclosureGroup(
                            isExpanded: $viewModel.isExpanded3,
                            content: {
                                VStack {
                                    buildSearchFieldView()
                                    Spacer()
                                    if viewModel.isSearchingMusic {
                                        progressView
                                        Spacer()
                                    } else if isSearchFromEmptyText {
                                        emptyMusic
                                        Spacer()
                                    } else {
                                        buildSearchResultScrollView()
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
                                .onChange(of: viewModel.musicTitle, perform: { _ in
                                    if viewModel.musicTitle.isEmpty {
                                        isSearchFromEmptyText = true
                                        viewModel.selectedMusic = nil
                                    }
                                })
                            }
                            ,
                            label: {
                                if viewModel.isExpanded3 {
                                    Text("프로젝트의 노래를 알려주세요")
                                        .foregroundStyle(Color.blueLight3)
                                        .font(.title3)
                                        .bold()
                                        .padding(.horizontal)
                                        .padding(.vertical, 20)
                                } else {
                                    HStack {
                                        Text("노래")
                                            .foregroundStyle(Color.gray)
                                        Spacer()

                                        Text("\(viewModel.artist) - \(viewModel.musicTitle)")
                                            .foregroundStyle(Color.gray)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 20)
                                }
                            })
                        .disclosureGroupBackground()
                    }
                        // 프로젝트 인원
                        HeadcountSetupView(performanceUseCase: viewModel.performanceUseCase)
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            // TODO: 전체삭제
                        } label: {
                            Text("전체삭제")
                                .underline()
                                .foregroundStyle(Color.monoNormal2)
                                .font(.title3)
                                .bold()
                                .padding(.bottom, 25)
                        }
                        Spacer()
                        buildNextButton()
                    }
                    .background(
                        Rectangle()
                            .frame(width: geometry.size.width, height: geometry.size.height/6.2)
                            .background(Color(hex: ("767680")).opacity(0.24))
                            .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: -3)
                    )
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 10)
                }
                .ignoresSafeArea(.all)
            }
            .background(
                Image("background")
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea(.all)
            )
            .navigationTitle("New project")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                leftItem
            }
            .padding(.top)
        }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color.blueLight3)
            }
        }
    }

 @ViewBuilder
 private func buildCell(music: Music) -> some View {
    HStack {
        AsyncImage(url: music.albumCoverURL) { image in
            image
                .image?.resizable()
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .frame(width: 90, height: 64, alignment: .leading)
                .aspectRatio(contentMode: .fill)
                .clipped()

        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea(.all)

        VStack(alignment: .leading) {
            Text(music.artistName)
                .font(.caption2)
            Text(music.title)
        }
        Spacer()

        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(
                viewModel.selectedMusic?.id ?? "-1" == music.id
                ? Color.blueLight3
                : Color.monoNormal3
            )
            .font(.title2)
    }
    .padding(.trailing)
    .background(
        RoundedRectangle(cornerRadius: 15)
            .stroke(
                viewModel.selectedMusic?.id ?? "-1" == music.id
                ? Color.blueLight3
                : .clear,
                lineWidth: 2
            )
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.monoNormal1)
            )
    )
    .frame(height: 64)
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

 private func buildSearchFieldView() -> some View {
    HStack {
        Image(systemName: "magnifyingglass")
            .foregroundStyle(Color.gray)

        TextField("가수, 노래 검색하기", text: $viewModel.musicTitle)
            .focused($isFocused)
            .font(.body)
            .bold()
            .onSubmit(of: .text) {
                searchMusic()
            }
            .submitLabel(.search)
            .foregroundStyle(Color.monoWhite3)
            .multilineTextAlignment(.center)
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .tint(Color.blueLight2)
        Spacer()

        Button {
            viewModel.musicTitle = ""
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.black)
                .opacity(viewModel.musicTitle.isEmpty ? 0 : 0.1)
        }
    }
    .font(.title3)
    .padding(.horizontal)
    .background(viewModel.musicTitle.isEmpty
                     ? Color.monoNormal1
                     : Color.blueLight2)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .padding()
 }

 private func buildEmptyMusicView() -> some View {
    Text("노래를 검색하세요")
        .foregroundStyle(Color.monoWhite2)
        .font(.headline)
        .bold()
 }

    private var emptyMusic: some View {
        Button {
            viewModel.selectedMusic = Music(id: "_", title: "_", artistName: "_")
        } label: {
            Image("emptyMusic")
                .padding()
        }
    }

    private var progressView: some View {
        Text("검색 중이에요")
            .foregroundStyle(Color.blueLight3)
            .font(.title3)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 20)
    }

 private func searchMusic() {
    viewModel.search()
    isSearchFromEmptyText = false
    isFocused = false
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

    private func buildNextButton() -> some View {
        NavigationLink {
            if let performance = viewModel.performance {

                viewModel.buildYameNextView(performance: performance)
            }
        } label: {
            Image("go_able")
                .padding(.bottom, 25)
        }
        .onTapGesture {
            viewModel.createPerformance()
        }
    }
}

struct DisclosureGroupBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.monoNormal1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Gradient.strokeGlass2)
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 3)
            .tint(.clear)
    }

}

extension View {
    func disclosureGroupBackground() -> some View {
        modifier(DisclosureGroupBackground())
    }
}
