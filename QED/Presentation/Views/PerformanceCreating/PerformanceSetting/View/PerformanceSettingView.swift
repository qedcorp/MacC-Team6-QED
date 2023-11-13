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
//    @State private var scrollToID: Int?
    //    @State private var revealDetails = false
    
    init(performanceUseCase: PerformanceUseCase) {
        self.viewModel = PerformanceSettingViewModel(
            performanceUseCase: performanceUseCase)
        viewModel.headcount = 2
    }
    
    var body: some View {
        GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                            ForEach(1..<4) { groupNum in
                                DisclosureGroup(
                                    isExpanded: bindingForIndex(groupNum),
                                    content: {
                                        disclosureContent(for: groupNum)
                                    },
                                    label: {
                                        disclosureLabel(for: groupNum)
                                    }
                                )
                                .disclosureGroupBackground()
                                .id(groupNum)
                            }
                    }
                    .frame(height: geometry.size.height)
                    .onChange(of: viewModel.scrollToID) { newID in
                        print("New scrollToID: \(String(describing: newID))")
                            proxy.scrollTo(newID, anchor: .top)
                    }
                    .onTapGesture {
                        endTextEditing()
                    }
                }
            
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            viewModel.allClear()
                        } label: {
                            Text("다시입력")
                                .underline()
                                .foregroundStyle(Color.monoNormal2)
                                .font(.title3)
                                .kerning(0.35)
                                .bold()
                                .padding(.bottom, 25)
                        }
                        
                        Spacer()
                        //                    buildNextButton()
                    }
                    .background(
                        Rectangle()
                            .frame(width: geometry.size.width, height: geometry.size.height/6.2)
                            .foregroundStyle(Color(red: 0.46, green: 0.46, blue: 0.5).opacity(0.24))
                            .shadow(color: .black.opacity(0.4), radius: 1.5, x: 0, y: -3)
                    )
                    .padding(.top, 5)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 25)
                }
                .ignoresSafeArea(.all)
        }
        .background(
            Image("background")
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leftItem
            ToolbarItem(placement: .principal) {
                Text("새 프로젝트")
                    .font(.body)
                    .bold()
                    .foregroundStyle(Color.monoWhite3)
            }
        }
        .padding(.top)
    }
    
    func bindingForIndex(_ groupNum: Int) -> Binding<Bool> {
        switch groupNum {
        case 1:
            return $viewModel.isExpanded1
        case 2:
            return $viewModel.isExpanded2
        case 3:
            return $viewModel.isExpanded3
        default:
            return .constant(false)
        }
    }
    
    @ViewBuilder
    func disclosureContent(for groupNum: Int) -> some View {
        switch groupNum {
        case 1:
            AnyView(inputTitleTextField)
        case 2:
            AnyView(musicContent)
        case 3:
            AnyView(inputHeadcountContent)
        default:
            AnyView(EmptyView())
        }
    }
    @ViewBuilder
    func disclosureLabel(for groupNum: Int) -> some View {
        switch groupNum {
        case 1:
            viewModel.isExpanded1 ? AnyView(inputTitleLabelClosed) :  AnyView(inputTitleLabelOpen)
        case 2:
            viewModel.isExpanded2 ? AnyView(inputMusicLabelClosed) : AnyView(inputMusicLabelOpened)
        case 3:
            viewModel.isExpanded3 ? AnyView(inputHeadcountlabelClosed) : AnyView(inputHeadcountlabelOpened)
        default:
            AnyView(EmptyView())
        }
    }
    
    var inputTitleTextField: some View {
        TextField("입력하세요", text: $viewModel.performanceTitle)
            .onSubmit {
                withAnimation {
                    viewModel.toggleDisclosureGroup2()
                    viewModel.scrollToID = 2
                }
            }
            .focused($isFocused)
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
            .disclosureGroupLabelStyle()
            .onAppear {
                viewModel.toggleDisclosureGroup1()
            }
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
    var inputMusicLabelClosed: some View {
        Text("프로젝트의 노래를 알려주세요")
            .disclosureGroupLabelStyle()
    }
    
    var inputMusicLabelOpened: some View {
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
    func buildCell(music: Music) -> some View {
        HStack {
            AsyncImage(url: music.albumCoverURL) { image in
                image
                    .image?.resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 64, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous).stroke(Color.clear, lineWidth: 1))
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.toggleDisclosureGroup3()
                }
            }
        }
        .id(music.id)
    }
    
    var musicContent: some View {
        VStack {
            musicSearchFieldView()
            Spacer()
            if viewModel.isSearchingMusic {
                ProgressView()
                    .tint(Color.blueNormal)
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
        .onChange(of: viewModel.musicTitle, perform: { _ in
            if viewModel.musicTitle.isEmpty {
                isSearchFromEmptyText = true
                viewModel.selectedMusic = nil
            }
        })
    }
    
    func buildSearchResultScrollView() -> some View {
        ScrollView {
            VStack {
                ForEach(viewModel.searchedMusics) { music in
                    buildCell(music: music)
                }
            }
            .padding(.vertical)
        }
    }
    
    func musicSearchFieldView() -> some View {
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
                isSearchFromEmptyText = true
                
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
    
    func buildEmptyMusicView() -> some View {
        Text("노래를 검색하세요")
            .foregroundStyle(Color.monoWhite2)
            .font(.headline)
            .bold()
    }
    
    var emptyMusic: some View {
        Button {
            viewModel.toggleDisclosureGroup3()
            viewModel.scrollToID = 3
            viewModel.selectedMusic = Music(id: "_", title: "_", artistName: "_")
        } label: {
            Image("emptyMusic")
                .padding()
        }
    }
    
    func searchMusic() {
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
        ScrollView {
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
        .frame(maxHeight: 411)
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
            .disclosureGroupLabelStyle()
    }
    
    var inputHeadcountlabelOpened: some View {
        HStack {
            Text("인원 수")
                .foregroundStyle(Color.gray)
            Spacer()
            
            Text("\(viewModel.headcount) 명")
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
