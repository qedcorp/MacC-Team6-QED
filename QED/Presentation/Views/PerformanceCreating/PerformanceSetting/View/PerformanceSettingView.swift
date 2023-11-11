//  swiftlint:disable all
//  PerformanceSettingView.swift
//  QED
//
//  Created by OLING on 11/6/23.
//

import Foundation
import SwiftUI



struct PerformanceSettingView: View {
    
    @State private var yameNextView: FormationSettingView? = nil
    @ObservedObject private var viewModel: PerformanceSettingViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState var isFocused: Bool
    @State private var isSearchFromEmptyText = true
    @State private var scrollToID: Int?
    
    //    @State private var revealDetails = false
    
    init(performanceUseCase: PerformanceUseCase) {
        self.viewModel = PerformanceSettingViewModel(
            performanceUseCase: performanceUseCase)
        viewModel.headcount = 2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack {
                            DisclosureGroup(
                                isExpanded: $viewModel.isExpanded1,
                                content: {
                                    inputTitleTextField
                                },
                                label: {
                                    if viewModel.isExpanded1 {
                                        inputTitleLabelClosed
                                    } else {
                                        inputTitleLabelOpen
                                    }
                                }
                            )
                            .disclosureGroupBackground()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isFocused = true
                                }
                            }
                            .id(1)
                            
                            DisclosureGroup(
                                isExpanded: $viewModel.isExpanded2,
                                content: {
                                    musicContent
                                }
                                ,
                                label: {
                                    if viewModel.isExpanded2 {
                                        inputMusicLabelClosed
                                    } else {
                                        inputMusicLabelOpened
                                    }
                                })
                            .disclosureGroupBackground()
                            .id(2)
                            
                            DisclosureGroup(
                                isExpanded: $viewModel.isExpanded3,
                                content: {
                                    inputHeadcountContent
                                },
                                
                                label: {
                                    if viewModel.isExpanded3 {
                                        inputHeadcountlabelClosed
                                    } else {
                                        inputHeadcountlabelOpened
                                    }
                                }
                            )
                            .disclosureGroupBackground()
                            .id(3)
                        }
                        .onChange(of: scrollToID) { value in
                            withAnimation {
                                proxy.scrollTo(value, anchor: .top)
                            }
                        }
                    }
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
//                    buildNextButton()
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
    
    var inputTitleTextField: some View {
        TextField("입력하세요", text: $viewModel.performanceTitle)
            .focused($isFocused)
            .onAppear {
                viewModel.toggleDisclosureGroup1()
            }
            .onSubmit {
                withAnimation {
                    scrollToID = 2
                    viewModel.toggleDisclosureGroup2()
                }
            }
            .foregroundStyle(viewModel.performanceTitle.isEmpty
                             ? Color.monoNormal2
                             : Color.monoWhite3)
            .multilineTextAlignment(.center)
            .font(.headline)
            .bold()
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(viewModel.performanceTitle.isEmpty
                                     ? Color.monoNormal1
                                     : Color.blueLight2)
            )
            .padding()
            .tint(Color.blueLight2)
    }
    
    var inputTitleLabelClosed: some View {
        Text("프로젝트 제목을 입력하세요")
            .foregroundStyle(Color.blueLight3)
            .font(.title3)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 20)
    }
    
    var inputTitleLabelOpen: some View {
        HStack {
            Text("프로젝트 제목")
                .foregroundStyle(Color.monoWhite2)
                .font(.subheadline)
            Spacer()
            
            if viewModel.performanceTitle.isEmpty {
                Text("_")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            } else {
                Text("\(viewModel.performanceTitle)")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
    }
    
    //music
    
    private var inputMusicLabelClosed: some View {
        Text("프로젝트의 노래를 알려주세요")
            .foregroundStyle(Color.blueLight3)
            .font(.title3)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 20)
    }
    
    private var inputMusicLabelOpened: some View {
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
        .id(music.id)
    }
    
    var musicContent: some View {
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
            isFocused = true
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
    
    private func buildSearchFieldView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray)
                .bold()
            
            TextField("가수, 노래 검색하기", text: $viewModel.musicSearch)
                .focused($isFocused)
                .onAppear {
                    viewModel.toggleDisclosureGroup2()
                }
                .font(.body)
                .bold()
                .onSubmit(of: .text) {
                    searchMusic()
                }
                .submitLabel(.search)
                .foregroundStyle(Color.monoWhite2)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
                .tint(Color.blueLight2)
            Spacer()
            
            Button {
                viewModel.musicSearch = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.black)
                    .opacity(viewModel.musicTitle.isEmpty ? 0 : 0.1)
            }
        }
        .font(.title3)
        .padding(.horizontal)
        .background(viewModel.musicSearch.isEmpty
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
            viewModel.toggleDisclosureGroup3()
//            scrollToID = 3
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
    
    
//    private func buildNextButton() -> some View {
//        NavigationLink {
//            buildYameNextView(
//                performance: viewModel.performance ?? Performance(id: "",
//                                                        author: User(),
//                                                        music: Music(id: "",
//                                                                     title: "",
//                                                                     artistName: ""),
//                                                        headcount: viewModel.headcount)
//            )
//        } label: {
//            Image("go_able")
//                .padding(.bottom, 25)
//        }
//    }
    
    var inputHeadcountContent: some View {
        VStack {
            ZStack {
                inputHeadcountTextField
                HStack {
                    Button {
                        viewModel.decrementHeadcount()
                    } label: {
                        Image("minus_on")
                    }
                    Spacer()
                    Button {
                        viewModel.incrementHeadcount()
                    } label: {
                        Image("plus_on")
                    }
                }
                .padding(.vertical)
            }
            .padding(.horizontal)
            slider
            headcountText
            inputMemperinfoTextFiledsView
        }
    }
    
    var inputHeadcountTextField: some View {
        Text("\(viewModel.headcount)")
            .onAppear {
                viewModel.toggleDisclosureGroup3()
            }
            .multilineTextAlignment(.center)
            .font(.title2)
            .bold()
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .foregroundColor(viewModel.headcount < 2 ? .gray : .black)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.monoNormal1)
                    .frame(width: 310)
            )
            .tint(Color.blueLight2)
        
    }
    
    var inputHeadcountlabelClosed: some View {
        Text("인원수를 입력하세요")
            .foregroundStyle(Color.blueLight3)
            .font(.title3)
            .bold()
            .padding(.horizontal)
            .padding(.vertical, 20)
    }
    
    var inputHeadcountlabelOpened: some View {
        HStack {
            Text("인원 수")
                .foregroundStyle(Color.gray)
            Spacer()
            
            Text("performaceinputheadcount")
                .foregroundStyle(Color.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
    }
    
    var headcountText: some View {
        Text("이름을 입력해서 동선을 확인할 수 있어요")
            .foregroundStyle(Color.monoWhite2)
            .font(.subheadline)
    }
    
    var slider: some View {
        Slider(
            value: .init(
                get: { Double(viewModel.headcount) },
                set: { viewModel.headcount = Int($0) }
            ),
            in: 2 ... 13,
            step: 1
        )
        .tint(Color.blueLight3)
        .frame(width: 320)
    }
    
    var inputMemperinfoTextFiledsView: some View {
        VStack {
            ForEach(Array(0..<viewModel.headcount), id: \.self) { index in
                if index < viewModel.inputMemberInfo.count {
                    TextField("인원 \(index + 1)", text: $viewModel.inputMemberInfo[index])
                        .focused($isFocused)
                        .foregroundStyle(Color.monoNormal2)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(viewModel.inputMemberInfo[index].isEmpty
                                                 ? Color.monoNormal1
                                                 : Color.blueLight2)
                        )
                        .padding(.horizontal)
                        .padding(.vertical, 3)
                        .tint(Color.blueLight2)
                    
                    Spacer()
                }
            }
        }
    }
    
//    func buildYameNextView(performance: Performance) -> some View {
//        Task  {
//            viewModel.createPerformance()
//        }
//        if yameNextView == nil {
//            yameNextView = FormationSettingView(
//                performance: performance, performanceUseCase: viewModel.performanceUseCase
//            )
//        }
//        return yameNextView!
//    }
    
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
