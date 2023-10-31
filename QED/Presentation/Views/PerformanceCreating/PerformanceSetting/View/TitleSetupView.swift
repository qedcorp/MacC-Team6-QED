//
//  TitleSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct TitleSetupView: View {
    @ObservedObject private var viewModel: PerformanceSettingViewModel
    @FocusState var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    init(performanceUseCase: PerformanceUseCase) {
        self.viewModel = PerformanceSettingViewModel(performanceUseCase: performanceUseCase)
    }

    var body: some View {
        VStack {
            Spacer()
            header
            projecttitle
            Spacer()
            nextbutton
        }
        .navigationTitle("이름 설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            leftItem
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }

    private var header: some View {
        HStack {
            Text("프로젝트 이름")
                .font(.system(size: 30))
                .bold()
            Spacer()
        }
        .padding()
    }

    private var projecttitle: some View {
        TextField("입력하세요", text: $viewModel.inputTitle)
            .focused($isFocused)
            .multilineTextAlignment(.center)
            .font(.system(size: 30))
            .bold()
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .background(
                Rectangle()
                    .foregroundColor(.clear)
                    .background(.white)
                    .cornerRadius(50)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
            )
            .padding(3)
    }

    private var leftItem: ToolbarItem<(), some View> {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .foregroundColor(Color(red: 0, green: 0.97, blue: 0.04))
            }
        }
    }

    private var nextbutton: some View {
        NavigationLink {
            HeadcountSetupView(viewModel: viewModel)
        } label: {
            Text("다음")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(viewModel.inputTitle.isEmpty
                            ? .black.opacity(0.2)
                            : .black)
                .cornerRadius(15)
        }
        .disabled(viewModel.inputTitle.isEmpty)
    }
}
