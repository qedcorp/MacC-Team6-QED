//
//  TitleSettingView.swift
//  QED
//
//  Created by OLING on 10/18/23.
//

import SwiftUI

struct TitleSettingView: View {

    @ObservedObject var performancesettingVM: PerformanceSettingViewModel
    @State var textFieldText: String = ""

    var body: some View {
        VStack {
            HStack {
                Text("프로젝트 이름")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
            }
            .padding()

            Spacer()

            TextField("입력하세요", text: $textFieldText)
                .font(.system(size: 30))
                .bold()
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.9))
                .padding(EdgeInsets(top: 15, leading: 100, bottom: 15, trailing: 0))
                .background(
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(.white)
                        .cornerRadius(50)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 0)
                )
                .padding()

            Spacer()
            NavigationLink {
                HeadcountView(performancesettingVM: performancesettingVM)
                    .navigationTitle("인원수 선택")
                    .navigationBarTitleDisplayMode(.inline)
                //                        .navigationBarBackButtonHidden(true)
            }label: {
                nextbutton
            }
        }
        .padding()
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
        TitleSettingView()
}
