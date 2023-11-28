// swiftlint:disable all
// PerformanceSettingView.swift
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
    @FocusState private var focusedIndex: Int?
    @Binding var path: [PresentType]

    init(viewModel: PerformanceSettingViewModel, path: Binding<[PresentType]>) {
        self.viewModel = viewModel
        self._path = path
        viewModel.headcount = 1
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        VStack {
                            ForEach(1..<4, id: \.self) { groupNum in
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
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(height: 600)
                        }
                    }
                    .onChange(of: viewModel.scrollToID) { newID in
                        withAnimation {
                            proxy.scrollTo(newID, anchor: .top)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.isFocused = true
                        }
                    }
                }
                VStack {
                    Spacer()
                    HStack(alignment: .center) {
                        Button {
                            viewModel.scrollToID = 1
                            viewModel.delete()
                        } label: {
                            Text("다시입력")
                                .underline()
                                .foregroundStyle(Color.monoNormal2)
                                .font(.title3)
                                .kerning(0.35)
                                .fontWeight(.bold)
                        }

                        Spacer()
                        nextButton
                            .disabled(!viewModel.isAllSet)

                    }
                    .padding(.bottom, 30)
                    .background(
                        Rectangle()
                            .frame(width: geometry.size.width, height: geometry.size.height/6.2)
                            .foregroundStyle(Gradient.unknownGradient1)
                            .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: -1)
                    )
                    .padding(.horizontal, 25)
                    .padding(.vertical, 10)
                }
            }
        }
        .background(
            Image("background")
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
        )
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leftItem
            ToolbarItem(placement: .principal) {
                Text("새 프로젝트")
                    .font(.body)
                    .fontWeight(.bold)
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
            AnyView(inputTitleContent)
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
            viewModel.isExpanded1 ? AnyView(inputTitleLabelOpend) :  AnyView(inputTitleLabelClosed)
        case 2:
            viewModel.isExpanded2 ? AnyView(inputMusicLabelOpend) : AnyView(inputMusicLabelClosed)
        case 3:
            viewModel.isExpanded3 ? AnyView(inputHeadcountlabelOpened) : AnyView(inputHeadcountlabelClosed)
        default:
            AnyView(EmptyView())
        }
    }

    var nextButton: some View {
        Image(viewModel.isAllSet
              ? "go_able"
              : "go_disabled")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 86, height: 44)
            .onTapGesture {
                let dependency = PerformanceLoadingViewDependency {
                    viewModel.getTaskForCreatePerformance()
                }
                path.append(.performanceLoading(dependency))
            }
    }

    var inputTitleContent: some View {
        TextField("ex) FODI 댄스타임", text: $viewModel.performanceTitle)
            .focused($isFocused)
            .foregroundStyle(Color.monoWhite3)
            .multilineTextAlignment(.center)
            .font(.headline)
            .padding(EdgeInsets(top: 13, leading: 10, bottom: 13, trailing: 10))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(viewModel.performanceTitle == ""
                                     ? Color.monoNormal1
                                     : Color.blueLight2)
            )
            .padding()
            .tint(Color.blueLight2)
            .onSubmit {
                withAnimation {
                    viewModel.toggleDisclosureGroup2()
                }
            }

    }
    

    var inputTitleLabelOpend: some View {
        Text("프로젝트 제목을 입력하세요")
            .disclosureGroupLabelStyle()
            .onAppear {
                viewModel.toggleDisclosureGroup1()
            }
    }

    var inputTitleLabelClosed: some View {
        HStack {
            Text("프로젝트 이름")
                .lineLimit(1)
                .foregroundStyle(Color.monoWhite2)
                .font(.subheadline)
            Spacer()

            if viewModel.performanceTitle.isEmpty {
                Text("입력해주세요")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            } else {
                Text("\(viewModel.performanceTitle)")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            }
        }
        . disclosureGroupLabelOpend()
    }

    var inputMusicLabelOpend: some View {
        Text("프로젝트의 노래를 알려주세요")
            .disclosureGroupLabelStyle()
    }

    var inputMusicLabelClosed: some View {
        HStack {
            Text("노래")
                .foregroundStyle(Color.monoWhite2)
                .font(.subheadline)
            Spacer()

            if viewModel.musicTitle == "" {
                Text("선택해주세요")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            } else if viewModel.musicTitle == "_" {
                Text("자체 노래 선택")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            } else {
                Text("\(viewModel.artist) - \(viewModel.musicTitle)")
                    .lineLimit(1)
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            }
        }
        .disclosureGroupLabelOpend()
        .onTapGesture {
            viewModel.toggleDisclosureGroup2()
        }
    }

    var inputHeadcountlabelOpened: some View {
        Text("인원수를 입력하세요")
            .disclosureGroupLabelStyle()
    }

    var inputHeadcountlabelClosed: some View {
        HStack {
            Text("인원 수")
                .foregroundStyle(Color.monoWhite2)
                .font(.subheadline)
            Spacer()

            if viewModel.headcount == 1 {
                Text("- 명")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            } else {
                Text("\(viewModel.headcount) 명")
                    .foregroundStyle(Color.monoWhite3)
                    .font(.subheadline)
            }
        }
        .onAppear {
            viewModel.scrollToID = 1
        }
        .disclosureGroupLabelOpend()
    }

    var musicContent: some View {
        VStack {
            musicSearchFieldView()
            Spacer()
            if viewModel.isSearchingMusic {
                FodiProgressView()
                    .padding(.vertical)
                Spacer()
            } else if isSearchFromEmptyText {
                emptyMusic
                Spacer()
            } else {
                buildSearchResultScrollView()
            }
        }
        .frame(maxHeight: 550)
        .onTapGesture {
            isFocused = true
        }
        .onChange(of: viewModel.musicTitle, perform: { _ in
            if viewModel.musicTitle.isEmpty {
                isSearchFromEmptyText = true
                viewModel.selectedMusic = nil
            }
        })
        .onAppear {
            isSearchFromEmptyText = true
        }
    }

    @ViewBuilder
    func buildCell(music: Music) -> some View {
        HStack {
            AsyncImage(url: music.albumCoverURL) { image in
                image
                    .image?.resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 64, alignment: .leading)
                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color.clear, lineWidth: 1))
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
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        viewModel.toggleDisclosureGroup3()
                    }
                }
            }
        }
        .id(music.id)
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
            TextField("가수, 노래 검색하기", text: $viewModel.musicSearch)
                .focused($isFocused)
                .font(.headline)
                .bold(!viewModel.musicSearch.isEmpty)
                .onSubmit(of: .text) {
                    searchMusic()
                }
                .onAppear {
                    viewModel.isExpanded1 = false
                    viewModel.isExpanded3 = false
                }
                .submitLabel(.search)
                .foregroundStyle(Color.monoWhite3)
                .multilineTextAlignment(.leading)
                .padding(EdgeInsets(top: 13, leading: 7, bottom: 13, trailing: 7))
                .tint(Color.blueLight2)
                .onTapGesture {
                    withAnimation {
                        viewModel.scrollToID = 2
                    }
                }
            Spacer()
            Button {
                searchMusic()
            } label: {
                Image("musicSearch")
            }
        }
        .font(.title3)
        .padding(.horizontal, 10)
        .background(viewModel.musicSearch == ""
                    ? Color.monoNormal1
                    : Color.blueLight2)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 10)
    }

    var emptyMusic: some View {
        Button {
            viewModel.toggleDisclosureGroup3()
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

    var inputHeadcountContent: some View {
        VStack {
                HStack {
                    Button {
                        viewModel.decrementHeadcount()
                    } label: {
                        Image(viewModel.headcount == 1
                            ? "minus_off"
                            : "minus_on"
                        )
                    }
                    Spacer()
                    inputHeadcountTextField
                    Spacer()
                    Button {
                        viewModel.incrementHeadcount()
                    } label: {
                        Image(viewModel.headcount == 13
                            ? "plus_off"
                            : "plus_on"
                        )
                    }
                }
                .background(
                RoundedRectangle(cornerRadius: 35)
                    .foregroundStyle(Color.monoNormal1)
                    .frame(width: 320)
                )
                .padding(.horizontal, 20)
            slider
            headcountText
            inputMemperinfoTextFiledsView
        }
        .frame(maxHeight: 360)
    }

    var inputHeadcountTextField: some View {
        Text("\(viewModel.headcount)")
            .onAppear {
                viewModel.toggleDisclosureGroup3()
            }
            .foregroundColor(viewModel.headcount < 2
                             ? .monoWhite2
                             : .monoWhite3)
            .multilineTextAlignment(.center)
            .font(.title3)
            .fontWeight(.bold)
            .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
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
            in: 1 ... 13,
            step: 1
        )
        .tint(Color.blueLight3)
        .frame(width: 320)
    }

    var inputMemperinfoTextFiledsView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(Array(0..<viewModel.headcount), id: \.self) { index in
                        if index < viewModel.inputMemberInfo.count {
                            TextField("인원 \(index + 1)", text: $viewModel.inputMemberInfo[index])
                                .focused($focusedIndex, equals: index)
                                .onSubmit {
                                    withAnimation {
                                        proxy.scrollTo(index + 1, anchor: .top)
                                        focusedIndex = index + 1
                                        viewModel.scrollToID = (index + 1 < viewModel.headcount)
                                        ? 3
                                        : 1
                                        if index == viewModel.headcount - 1 {
                                            viewModel.isExpanded3 = false
                                        }
                                    }
                                }
                                .onTapGesture {
                                    viewModel.scrollToID = 3
                                }
                                .foregroundStyle(Color.monoWhite3)
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .foregroundStyle(viewModel.inputMemberInfo[index].isEmpty
                                                         ? Color.monoNormal1
                                                         : isFocused
                                                            ? Color.darker2
                                                            : Color.blueLight2
                                                        )
                                )
                                .padding(.horizontal)
                                .padding(.vertical, 3)
                                .tint(Color.blueLight2)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            AlertableBackButton(alert: .home, dismiss: dismiss)
        }
    }
}
