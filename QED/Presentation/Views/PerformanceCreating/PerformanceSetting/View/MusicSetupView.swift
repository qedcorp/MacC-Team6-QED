//
//  MusicSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct MusicSetupView: View {
    @StateObject var viewmodel: PerformanceSettingViewModel
    @FocusState private var isFocusedSearchTextField: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            searchField
            Spacer()
            if viewmodel.isSearchingMusic {
                ProgressView()
                Spacer()
            } else if viewmodel.searchText == "" {
                emptyMusic
                Spacer()
            } else {
                ScrollView {
                    VStack {
                        ForEach(viewmodel.searchedMusics) { music in
                            cell(music: music)
                        }
                    }
                    .padding(.vertical)
                }
            }
            NavigationLink {
                if let performance = viewmodel.performance {
                    viewmodel.buildYameNextView(performance: performance)
                }
            } label: {
                nextbutton
            }
            .disabled(viewmodel.selectedMusic == nil)
            .padding()
        }
        .onTapGesture {
            isFocusedSearchTextField = false
        }
        .navigationTitle("노래 선택")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leftItem
        }
    }

    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray)
            TextField(" 가수,노래", text: $viewmodel.searchText)
                .onSubmit(of: .text) {
                    viewmodel.search()
                }
                .focused($isFocusedSearchTextField)

            Spacer()
            Image(systemName: "xmark.circle.fill")
                .onTapGesture {
                    viewmodel.searchText = ""
                    viewmodel.selectedMusic = nil
                }
                .font(.title)
                .foregroundColor(.black)
                .opacity(viewmodel.searchText.isEmpty ? 0 : 0.1)
        }
        .font(.system(size: 20))
        .foregroundStyle(Color.black)
        .padding(7)
        .background(
            Rectangle()
                .foregroundStyle(Color.black)
                .opacity(0.08)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
        )
        .padding()
    }

    private var emptyMusic: some View {
        Text("노래를 검색하세요")
            .font(
                Font.custom("Apple SD Gothic Neo", size: 30)
                    .weight(.bold)
            )
            .foregroundColor(Color(red: 0.76, green: 0.76, blue: 0.76))
    }

    @ViewBuilder
    func cell(music: Music) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(music.artistName)
                    .font(.caption2)
                Text(music.title)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(
                    viewmodel.selectedMusic?.id ?? "-1" == music.id
                    ? Color.green
                    : Color.gray.opacity(0.2)
                )
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    viewmodel.selectedMusic?.id ?? "-1" == music.id
                    ? Color.green
                    : Color.gray, lineWidth: 2
                )
                .foregroundStyle(Color.gray
                    .opacity(0.1))
                .padding(EdgeInsets())
        )
        .padding(.horizontal)
        .onTapGesture {
            viewmodel.selectedMusic = music
        }
    }

    private var nextbutton: some View {
        Text("다음")
            .frame(width: 340, height: 54)
            .font(
                Font.custom("Apple SD Gothic Neo", size: 16)
                    .weight(.bold)
            )
            .foregroundColor(.white)
            .background(viewmodel.selectedMusic == nil
                        ? Color.black.opacity(0.2)
                        : Color.black
            )
            .cornerRadius(14)
    }

    private var leftItem: ToolbarItem<(), some View> {
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
