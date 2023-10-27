//
//  TitleSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct TitleSetupView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel
    @FocusState var isFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack {
                    Text("프로젝트 이름")
                        .font(.system(size: 30))
                        .bold()
                    Spacer()
                }
                .padding()

                TextField("입력하세요", text: $performancesettingVM.inputTitle)
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

                Spacer()

                NavigationLink {
                    HeadcountSetupView(performancesettingVM: performancesettingVM)
                        .navigationTitle("인원수 선택")
                        .navigationBarTitleDisplayMode(.inline)
                } label: {
                    nextbutton
                }
                .disabled(performancesettingVM.inputTitle.isEmpty)
            }
            .navigationTitle("이름 설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isFocused = true
                }
            }
        }
    }

    var nextbutton: some View {
        Text("다음")
            .frame(width: 340, height: 54)
            .font(
                Font.custom("Apple SD Gothic Neo", size: 16)
                    .weight(.bold)
            )
            .foregroundColor(.white)
            .background(performancesettingVM.inputTitle.isEmpty
                        ? Color.black.opacity(0.2)
                        : Color.black)
            .cornerRadius(14)
            .padding()
    }
}

#Preview {
    TitleSetupView(performancesettingVM: PerformanceSettingViewModel())
}
