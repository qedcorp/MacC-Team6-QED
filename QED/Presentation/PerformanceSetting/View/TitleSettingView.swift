//
//  TitleSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct TitleSettingView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel
    @FocusState var isFocused: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("프로젝트 이름")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
            }
            .padding()

            TextField("입력하세요", text: $performancesettingVM.textFieldText)
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
                HeadcountView(performancesettingVM: performancesettingVM)
                    .navigationTitle("인원수 선택")
                    .navigationBarTitleDisplayMode(.inline)
            }label: {
                nextbutton
            }
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isFocused = true
            }
        }

    }

    var nextbutton: some View {
        Text("다음")
            .frame(width: 360, height: 54)
            .font(
                Font.custom("Apple SD Gothic Neo", size: 16)
                    .weight(.bold)
            )
            .foregroundColor(.white)
            .background(Color.black)
            .cornerRadius(14)
    }
}

#Preview {
    TitleSettingView(performancesettingVM: PerformanceSettingViewModel())
}
