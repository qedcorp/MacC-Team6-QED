//
//  MusicSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct MusicSettingView: View {
    @ObservedObject var performanceSettingVM: PerformanceSettingViewModel
    @FocusState private var isFocusedSearchTextField: Bool
    @Environment(\.presentationMode) var presentationMode: Binding

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.gray)
                    TextField(" 가수,노래", text: $performanceSettingVM.searchText)
                        .onSubmit(of: .text) {
                            performanceSettingVM.search()
                        }
                        .focused($isFocusedSearchTextField)
                    Spacer()
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            performanceSettingVM.searchText = ""
                        }
                        .font(.title)
                        .foregroundColor(.black)
                        .opacity(performanceSettingVM.searchText.isEmpty ? 0 : 0.1)
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
                Spacer()
                if performanceSettingVM.isSearchingMusic {
                    ProgressView()
                    Spacer()
                } else if performanceSettingVM.searchText == "" {
                    Text("노래를 검색하세요")
                        .font(
                        Font.custom("Apple SD Gothic Neo", size: 30)
                        .weight(.bold)
                        )
                        .foregroundColor(Color(red: 0.76, green: 0.76, blue: 0.76))
                    Spacer()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(performanceSettingVM.searchedMusics) { music in
                                cell(music: music)
                            }
                        }
                    }
                }
                NavigationLink {
                    settingFinishView
                } label: {
                    nextbutton
                }
                .disabled(performanceSettingVM.selectedMusic == nil)
            }
        }
        .onTapGesture {
            isFocusedSearchTextField = false
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }

    var settingFinishView: some View {
            Text("팀 생성 완료")
                .font(.largeTitle)
                .bold()
    }

    var nextbutton: some View {
        Text("다음")
            .frame(width: 360, height: 54)
            .font(
                Font.custom("Apple SD Gothic Neo", size: 16)
                    .weight(.bold)
            )
            .foregroundColor(.white)
            .background(performanceSettingVM.selectedMusic == nil
                        ? Color.black.opacity(0.2)
                        : Color.black
            )
            .cornerRadius(14)
    }

    var btnBack: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left")
                    .aspectRatio(contentMode: .fit)
            }
            .foregroundStyle(.green)
        }
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
                .foregroundColor(.gray)
                .opacity(0.2)
                .font(.title2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    performanceSettingVM.selectedMusic?.id ?? "-1" == music.id
                    ? Color.green
                    : Color.gray, lineWidth: 2
                )
                .foregroundStyle(Color.gray
                    .opacity(0.1))
                .padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
        )
        .padding(.horizontal)
        .onTapGesture {
            performanceSettingVM.selectedMusic = music
        }
    }

}

#Preview {
    MusicSettingView(performanceSettingVM: PerformanceSettingViewModel())
}
